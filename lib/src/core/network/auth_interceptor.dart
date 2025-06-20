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
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken'; // ✅ ЭТО ГЛАВНОЕ
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        log("♻️ Refresh token used: $refreshToken");
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

          final newAccess = refreshResponse.data['access'];
          final newRefresh = refreshResponse.data['refresh'] ?? refreshToken;

          log("✅ New tokens received");
          await tokenStorage.saveTokens(newAccess, newRefresh);

          final clone = err.requestOptions;
          clone.headers['Authorization'] = 'Bearer $newAccess';

          final retryResponse = await dio.fetch(clone);
          return handler.resolve(retryResponse);
        } catch (e) {
          log("❌ Refresh failed: $e");
          await tokenStorage.clearTokens();
        }
      } else {
        log("🚫 No refresh token available");
      }
    }

    handler.next(err);
  }
}
