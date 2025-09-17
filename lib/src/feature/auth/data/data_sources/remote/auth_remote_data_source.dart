import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/auth/data/models/auth_model.dart';
import 'package:aps_mobile/src/feature/auth/data/models/login_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, LoginResponseModel>> login(
      String username, String password);
  Future<Either<Failure, Unit>> register(AuthModel user);
  Future<Either<Failure, AuthModel>> getUserById(int id);
  Future<Either<Failure, Unit>> deleteUserById(int id);
}
