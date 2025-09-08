import 'dart:developer';

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, LoginResponseModel>> login(
    String username,
    String password,
  ) async {
    final result = await authRemoteDataSource.login(username, password);

    return result.fold<Future<Either<Failure, LoginResponseModel>>>(
      (l) async => Left(l),
      (model) async {
        final access = model.access;
        final refresh = model.refresh;

        if (access != null && refresh != null) {
          await AuthTokenStorage().saveTokens(access, refresh);
        } else {
          log('⚠️ access/refresh token missing in response!');
        }

        await authLocalDataSource.saveUserMeta(
          companyId: model.companyId,
          userId: model.userId,
        );
        log("✅ Saved company id: ${model.companyId}");
        log("✅ Saved user id: ${model.userId}");

        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> register(AuthEntity user) async {
    return await authRemoteDataSource.register(user);
  }

  @override
  Future<bool> isLoggedIn() async => await authLocalDataSource.isLoggedIn();

  @override
  Future<Either<Failure, Unit>> logOut() async {
    final result = await authLocalDataSource.logOut();
    return result.fold<Either<Failure, Unit>>(
      (e) => Left(Failure(e.toString())),
      (_) => const Right(unit),
    );
  }

  @override
  Future<Either<Failure, AuthEntity>> getUserById(int id) async {
    final res = await authRemoteDataSource.getUserById(id);
    return res.map<AuthEntity>((model) => model);
  }

  @override
  Future<Either<Failure, Unit>> deleteUserById(int id) async {
    return await authRemoteDataSource.deleteUserById(id);
  }
}
