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
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshResponse = await dio.post(
            AppApi.refreshToken,
            options: Options(
              headers: {'Authorization': 'Bearer $refreshToken'},
            ),
          );

          final newAccess = refreshResponse.data['access'];
          final newRefresh = refreshResponse.data['refresh'];

          await tokenStorage.saveTokens(newAccess, newRefresh);

          final clone = err.requestOptions;
          clone.headers['Authorization'] = 'Bearer $newAccess';

          final retryResponse = await dio.fetch(clone);
          return handler.resolve(retryResponse);
        } catch (e) {
          await tokenStorage.clearTokens();
        }
      }
    }

    handler.next(err);
  }
}
