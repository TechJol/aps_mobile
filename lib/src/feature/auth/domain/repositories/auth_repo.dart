import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseModel>> login(
    String username,
    String password,
  );
  Future<Either<Failure, Unit>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> getUserById(int id);
  Future<Either<Failure, Unit>> deleteUserById(int id);

  Future<Either<Failure, Unit>> logOut();
  Future<bool> isLoggedIn();
}
