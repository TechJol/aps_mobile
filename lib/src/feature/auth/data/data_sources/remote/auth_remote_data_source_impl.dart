import 'package:aps_mobile/src/feature/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Either> login(AuthEntity user) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either> register(AuthEntity user) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
