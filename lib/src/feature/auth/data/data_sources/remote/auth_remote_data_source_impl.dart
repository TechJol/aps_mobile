import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
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
      final raw = e.response?.data?.toString() ?? e.message ?? 'Registration failed';
      final friendly = _mapRegistrationError(raw);
      return Left(Failure(friendly, code: e.response?.statusCode));
    }
  }

  /// Преобразуем «шумные» ошибки бэкенда (HTML/stacktrace)
  /// в понятные пользователю сообщения на русском.
  String _mapRegistrationError(String raw) {
    final text = raw.toLowerCase();

    // Частые кейсы уникальности
    if (text.contains('duplicate') || text.contains('unique constraint')) {
      // Компания уже существует
      if (text.contains("main_company.name") ||
          text.contains('company') && text.contains('name')) {
        return t.auth.errors.companyExists;
      }
      // Email
      if (text.contains('email')) {
        return t.auth.errors.emailExists;
      }
      // Username / user
      if (text.contains('username') || text.contains('users_user.username')) {
        return t.auth.errors.usernameExists;
      }
    }

    // Если сервер отдал HTML от Django — уберём лишнее и вернём общий текст
    if (text.contains('integrityerror')) {
      return t.auth.errors.unknown;
    }

    // По умолчанию — общий текст
    return t.auth.errors.unknown;
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
