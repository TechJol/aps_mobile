import 'package:dartz/dartz.dart';

abstract class AuthLocalDataSource {
  Future<bool> isLoggedIn();
  Future<Either<Object, bool>> logOut();
  Future<void> saveUserMeta({int? userId, int? companyId});
  Future<int?> getUserId();
  Future<int?> getCompanyId();
}
