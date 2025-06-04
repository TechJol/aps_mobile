import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Either> login(AuthEntity user) async {
    return await authRemoteDataSource.login(user);
  }

  @override
  Future<Either> register(AuthEntity user) async {
    return await authRemoteDataSource.register(user);
  }
}
