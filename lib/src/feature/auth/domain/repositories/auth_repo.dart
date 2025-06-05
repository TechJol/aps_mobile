import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> login(String username, String password);
  Future<Either> register(AuthEntity user);

  Future<Either> logOut();
  Future<bool> isLoggedIn();
}
