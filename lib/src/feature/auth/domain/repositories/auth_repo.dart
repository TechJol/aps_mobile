import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_entity.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_session.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> login(
    String username,
    String password,
  );
  Future<Either<Failure, Unit>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> getUserById(int id);
  Future<Either<Failure, Unit>> deleteUserById(int id);

  Future<Either<Failure, Unit>> logOut();
  Future<bool> isLoggedIn();
  Future<int?> getStoredUserId();
  Future<int?> getStoredCompanyId();
}
