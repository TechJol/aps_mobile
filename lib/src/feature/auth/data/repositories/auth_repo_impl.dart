import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either> login(AuthEntity user) async {
    return await authRemoteDataSource.login(user);
  }

  @override
  Future<Either> register(AuthEntity user) async {
    return await authRemoteDataSource.register(user);
  }

  @override
  Future<bool> isLoggedIn() async => await authLocalDataSource.isLoggedIn();

  @override
  Future<Either> logOut() async => await authLocalDataSource.logOut();
}
