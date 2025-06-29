import 'dart:developer';

import 'package:aps_mobile/src/core/core.dart';
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

    return result.fold((l) => Left(l), (r) async {
      Map<String, dynamic> response = r;

      final access = response['access'];
      final refresh = response['refresh'];

      if (access != null && refresh != null) {
        await AuthTokenStorage().saveTokens(access, refresh);
      } else {
        log('⚠️ access/refresh token missing in response!');
      }

      SharedPreferences storage = await SharedPreferences.getInstance();
      storage.setInt('companyId', response['company_id']);
      storage.setInt('userId', response['user_id']);

      log("✅ Saved company id: ${response['company_id']}");
      log("✅ Saved user id: ${response['user_id']}");
      return Right(response);
    });
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
        // storage.setString('accessToken', response['access']);
        // storage.setString('refreshToken', response['refresh']);
        storage.setInt('companyId', response['company_id']);
        storage.setInt('userId', response['user_id']);

        log("Bul company id ${response['company_id']}");
        log("Bul user id ${response['user_id']}");
        return Right(response);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async => await authLocalDataSource.isLoggedIn();

  @override
  Future<Either> logOut() async => await authLocalDataSource.logOut();

  @override
  Future<Either> getUserById(int id) async {
    return await authRemoteDataSource.getUserById(id);
  }
}
