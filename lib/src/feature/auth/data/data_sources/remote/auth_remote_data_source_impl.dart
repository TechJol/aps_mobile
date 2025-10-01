import 'package:aps_mobile/src/core/core.dart';
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
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> register(AuthModel user) async {
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
        data: user.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(Failure('Failed to register', code: response.statusCode));
      }
    } on DioException catch (e) {
      final raw = NetworkErrorMapper.toMessage(e);
      final friendly = _mapRegistrationError(raw);
      return Left(Failure(friendly, code: e.response?.statusCode));
    }
  }

  String _mapRegistrationError(String raw) {
    final text = raw.toLowerCase();

    if (text.contains('duplicate') || text.contains('unique constraint')) {
      if (text.contains("main_company.name") ||
          text.contains('company') && text.contains('name')) {
        return AuthErrorCodes.companyExists;
      }

      if (text.contains('email')) {
        return AuthErrorCodes.emailExists;
      }

      if (text.contains('username') || text.contains('users_user.username')) {
        return AuthErrorCodes.usernameExists;
      }
    }

    if (text.contains('integrityerror')) {
      return AuthErrorCodes.unknown;
    }

    return AuthErrorCodes.unknown;
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
      final msg = NetworkErrorMapper.toMessage(e);
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

      return const Right(unit);
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }
}
