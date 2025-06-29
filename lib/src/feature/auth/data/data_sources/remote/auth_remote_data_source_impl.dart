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
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data}');
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
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: (user as AuthModel).toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to register. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.response?.data}');
    }
  }

  @override
  Future<Either> getUserById(int id) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        '${AppApi.users}$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to get reason. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Обработка ошибки 401 (неверный или истёкший токен)
      if (e is DioException && e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }
}
