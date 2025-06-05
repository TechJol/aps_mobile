import 'package:dartz/dartz.dart';

abstract class AuthLocalDataSource {
  Future<bool> isLoggedIn();
  Future<Either> logOut();
}
