import 'dart:developer';

import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthTokenStorage tokenStorage;

  AuthInterceptor({required this.dio, required this.tokenStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    if (accessToken == null) {
      // Если access_token не найден, обрабатываем
      log("No access token found!");
    } else {
      log("Access token used: $accessToken");
      // Далее выполняем запрос с токеном
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        log("Refresh token used: $refreshToken");
        try {
          final refreshResponse = await sl<DioClient>().post(
            AppApi.refresh,

            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
              },
            ),
            data: {'refresh': refreshToken},
          );

          log("Server response: ${refreshResponse.data}");

          final newAccess = refreshResponse.data['access'];
          final newRefresh = refreshResponse.data['refresh'];

          log("New tokens received: Access: $newAccess, Refresh: $newRefresh");

          await tokenStorage.saveTokens(newAccess, newRefresh);

          final clone = err.requestOptions;
          clone.headers['Authorization'] = 'Bearer $newAccess';
          clone.headers['Accept'] = 'application/json';
          clone.headers['Content-Type'] = 'application/json';
          clone.headers['X-CSRFTOKEN'] = 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE';

          log("Retrying request with new access token");

          final retryResponse = await dio.fetch(clone);
          return handler.resolve(retryResponse);
        } catch (e) {
          log("Error while refreshing token: $e");
          await tokenStorage.clearTokens();
        }
      }
    }

    handler.next(err);
  }
}
