import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> login(String username, String password) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.login,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];

        // Логируем токены перед сохранением
        print(
          "Saving access token: $accessToken, refresh token: $refreshToken",
        );

        // Сохраняем токены в хранилище и ждём завершения операции
        await AuthTokenStorage().saveTokens(accessToken, refreshToken);

        // Возвращаем успешный результат
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to sign up. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Something went wrong with login: ${e.response?.data}');
    }
  }

  @override
  Future<Either> register(AuthEntity user) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.register,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
        data: (user as AuthModel).toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to sign up. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Something went wrong with login: ${e.response?.data}');
    }
  }
}
