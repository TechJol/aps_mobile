// Метод для обработки ошибки 401
import 'package:aps_mobile/src/core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthError {
  final Dio dio;

  AuthError({required this.dio});

  Future<Either> handleUnauthorized() async {
    try {
      // Получаем refresh токен
      final refreshToken = await AuthTokenStorage().getRefreshToken();

      if (refreshToken == null) {
        return Left(Exception('No refresh token available.'));
      }

      // Запрос на обновление токенов
      final response = await dio.post(
        AppApi.refreshToken,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      // Получаем новые токены
      final newAccessToken = response.data['access'];
      final newRefreshToken = response.data['refresh'];

      // Сохраняем новые токены
      await AuthTokenStorage().saveTokens(newAccessToken, newRefreshToken);

      // Повторно выполняем запрос с новым access token
      final originalRequest = response.requestOptions;
      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResponse = await dio.fetch(originalRequest);

      return Right(retryResponse.data);
    } catch (e) {
      return Left(Exception('Failed to refresh token: ${e.toString()}'));
    }
  }
}
