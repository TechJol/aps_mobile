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
      print("No access token found!");
    } else {
      print("Access token used: $accessToken");
      // Далее выполняем запрос с токеном
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        print("Refresh token used: $refreshToken");
        try {
          final refreshResponse = await sl<DioClient>().post(
            AppApi.refreshToken,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $refreshToken',
                'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
              },
            ),
          );

          print("Server response: ${refreshResponse.data}");

          final newAccess = refreshResponse.data['access'];
          final newRefresh = refreshResponse.data['refresh'];

          print(
            "New tokens received: Access: $newAccess, Refresh: $newRefresh",
          );

          await tokenStorage.saveTokens(newAccess, newRefresh);

          final clone = err.requestOptions;
          clone.headers['Authorization'] = 'Bearer $newAccess';

          print("Retrying request with new access token");

          final retryResponse = await dio.fetch(clone);
          return handler.resolve(retryResponse);
        } catch (e) {
          print("Error while refreshing token: $e");
          await tokenStorage.clearTokens();
        }
      }
    }

    handler.next(err);
  }
}
