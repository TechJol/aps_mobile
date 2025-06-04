import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> login(AuthEntity user);
  Future<Either> register(AuthEntity user);
}
