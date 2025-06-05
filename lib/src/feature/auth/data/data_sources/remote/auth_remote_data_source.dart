import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  Future<Either> login(String username, String password);
  Future<Either> register(AuthEntity user);
}
