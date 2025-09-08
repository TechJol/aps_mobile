import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.client});

  final DioClient client;

  @override
  Future<Either<Failure, LoginResponseModel>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await client.post(
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
        final model = LoginResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        return Right(model);
      } else {
        return Left(Failure('Failed to login', code: response.statusCode));
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Login failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> register(AuthEntity user) async {
    try {
      final response = await client.post(
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
        return const Right(unit);
      } else {
        return Left(Failure('Failed to register', code: response.statusCode));
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?.toString() ?? e.message ?? 'Registration failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> getUserById(int id) async {
    try {
      final response = await client.get(
        '${AppApi.users}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = AuthModel.fromJson(response.data as Map<String, dynamic>);
        return Right(model);
      } else {
        return Left(Failure('Failed to get user', code: response.statusCode));
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUserById(int id) async {
    try {
      await client.delete(
        '${AppApi.users}$id/',
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );
      // If no exception thrown, treat as success (e.g., 204/200)
      return const Right(unit);
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Delete failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }
}
