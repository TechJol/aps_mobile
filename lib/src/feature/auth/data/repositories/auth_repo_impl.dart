import 'dart:developer';

import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/core/network/auth_token_storage.dart';
import 'package:aps_mobile/src/feature/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:aps_mobile/src/feature/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:aps_mobile/src/feature/auth/data/models/auth_model.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_entity.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_session.dart';
import 'package:aps_mobile/src/feature/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, AuthSession>> login(
    String username,
    String password,
  ) async {
    final result = await authRemoteDataSource.login(username, password);

    return result.fold<Future<Either<Failure, AuthSession>>>(
      (l) async => Left(l),
      (model) async {
        final access = model.access;
        final refresh = model.refresh;

        if (access != null && refresh != null) {
          await tokenStorage.saveTokens(access, refresh);
        } else {
          log('⚠️ access/refresh token missing in response!');
        }

        await authLocalDataSource.saveUserMeta(
          companyId: model.companyId,
          userId: model.userId,
        );
        log("✅ Saved company id: ${model.companyId}");
        log("✅ Saved user id: ${model.userId}");

        return Right(model.toSession());
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> register(AuthEntity user) async {
    final authModel = AuthModel.fromEntity(user);
    return await authRemoteDataSource.register(authModel);
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

  @override
  Future<int?> getStoredUserId() async {
    return authLocalDataSource.getUserId();
  }

  @override
  Future<int?> getStoredCompanyId() async {
    return authLocalDataSource.getCompanyId();
  }
}
