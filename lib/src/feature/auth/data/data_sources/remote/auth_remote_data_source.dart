import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, LoginResponseModel>> login(
      String username, String password);
  Future<Either<Failure, Unit>> register(AuthEntity user);
  Future<Either<Failure, AuthModel>> getUserById(int id);
  Future<Either<Failure, Unit>> deleteUserById(int id);
}
