import 'dart:developer';

import 'package:aps_mobile/injection_container.dart';
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
        log("No refresh token available!");
        return Left(Exception('No refresh token available.'));
      }

      // Логируем refresh token для отладки
      log("Refresh token used: $refreshToken");

      // Запрос на обновление токенов
      final response = await sl<DioClient>().post(
        AppApi.refresh,

        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: {
          'refresh': refreshToken, // Передаем refresh token в теле запроса
        },
      );

      // Логируем ответ от сервера
      log("Server response: ${response.data}");

      // Получаем новые токены
      final newAccessToken = response.data['access'];
      final newRefreshToken = response.data['refresh'];

      // Логируем новые токены для отладки
      log(
        "New tokens received: Access: $newAccessToken, Refresh: $newRefreshToken",
      );

      // Сохраняем новые токены в хранилище
      await AuthTokenStorage().saveTokens(newAccessToken, newRefreshToken);

      // Повторно выполняем запрос с новым access token
      final originalRequest = response.requestOptions;
      originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
      originalRequest.headers['Content-Type'] =
          'application/json'; // Устанавливаем Content-Type
      originalRequest.headers['Accept'] =
          'application/json'; // Устанавливаем Accept
      originalRequest.headers['X-CSRFTOKEN'] =
          'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE'; // Или используйте актуальный CSRF-токен

      // Логируем обновленные заголовки для отладки
      log("Updated headers: ${originalRequest.headers}");

      // Повторно выполняем запрос с обновленными заголовками
      final retryResponse = await dio.fetch(originalRequest);
      return Right(retryResponse.data);
    } catch (e) {
      // Логируем ошибку
      log("Error while refreshing token: $e");
      return Left(Exception('Failed to refresh token: ${e.toString()}'));
    }
  }
}
