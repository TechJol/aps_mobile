import 'dart:developer';

import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart'; // <-- чтобы вызвать sl<AuthCubit>().logout()
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthTokenStorage tokenStorage;

  // защита от параллельных refresh
  bool _isRefreshing = false;

  AuthInterceptor({required this.dio, required this.tokenStorage});

  bool _isRefreshRequest(RequestOptions o) {
    // помечаем refresh-запрос флагом extra['skipAuth']=true и/или по пути
    return o.extra['skipAuth'] == true || o.path.contains(AppApi.refresh);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Не добавляем Bearer для refresh-запросов
    if (!_isRefreshRequest(options)) {
      final accessToken = await tokenStorage.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;

    // Если 401 пришёл именно на refresh — значит refresh истёк/невалиден.
    if (is401 && _isRefreshRequest(err.requestOptions)) {
      log('🚫 Refresh token invalid/expired');
      await tokenStorage.clearTokens();

      // сообщаем приложению — выходим в логин
      try {
        sl<AuthCubit>().logout();
      } catch (_) {}
      return handler.next(err);
    }

    // Обычные запросы с 401 — пробуем обновить токены
    if (is401 && !_isRefreshRequest(err.requestOptions)) {
      // если уже обновляем — просто повторим запрос после обновления
      if (_isRefreshing) {
        try {
          // подождём немного, пока идёт другой refresh
          await Future.doWhile(() async {
            await Future.delayed(const Duration(milliseconds: 120));
            return _isRefreshing;
          });
          final newAccess = await tokenStorage.getAccessToken();
          if (newAccess != null) {
            final clone = err.requestOptions;
            clone.headers['Authorization'] = 'Bearer $newAccess';
            final retry = await dio.fetch(clone);
            return handler.resolve(retry);
          }
        } catch (_) {
          // если не удалось — падаем в общий обработчик ниже
        }
      }

      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        log("🚫 No refresh token available");
        await tokenStorage.clearTokens();
        try {
          sl<AuthCubit>().logout();
        } catch (_) {}
        return handler.next(err);
      }

      // Выполняем refresh
      try {
        _isRefreshing = true;

        final refreshResponse = await dio.post(
          AppApi.refresh,
          data: {'refresh': refreshToken},
          options: Options(
            extra: {
              'skipAuth': true,
            }, // <-- не пропускать через onRequest/onError
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
            },
          ),
        );

        final newAccess = refreshResponse.data['access'] as String?;
        final newRefresh =
            (refreshResponse.data['refresh'] as String?) ?? refreshToken;

        if (newAccess == null) throw Exception('No access in refresh response');

        await tokenStorage.saveTokens(newAccess, newRefresh);

        // повторяем исходный запрос
        final clone = err.requestOptions;
        clone.headers['Authorization'] = 'Bearer $newAccess';
        final retryResponse = await dio.fetch(clone);
        return handler.resolve(retryResponse);
      } catch (e) {
        log("❌ Refresh failed: $e");
        await tokenStorage.clearTokens();
        try {
          sl<AuthCubit>().logout();
        } catch (_) {}
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }

    // Прочие ошибки — как есть
    handler.next(err);
  }
}
