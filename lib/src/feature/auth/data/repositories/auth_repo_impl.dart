import 'dart:developer';

import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either> login(String username, String password) async {
    Either result = await authRemoteDataSource.login(username, password);

    return result.fold(
      (l) {
        return Left(l);
      },
      (r) async {
        Map<String, dynamic> response = r;

        SharedPreferences storage = await SharedPreferences.getInstance();
        storage.setString('accessToken', response['access']);
        final companyId = storage.setInt('companyId', response['company_id']);

        log(companyId.toString());
        return Right(response);
      },
    );
  }

  @override
  Future<Either> register(AuthEntity user) async {
    final Either result = await authRemoteDataSource.register(user);
    return result.fold(
      (l) {
        return Left(l);
      },
      (r) async {
        Map<String, dynamic> response = r;

        SharedPreferences storage = await SharedPreferences.getInstance();
        storage.setString('accessToken', response['access']);

        return Right(response);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async => await authLocalDataSource.isLoggedIn();

  @override
  Future<Either> logOut() async => await authLocalDataSource.logOut();
}
