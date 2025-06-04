import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> login(AuthEntity user) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.login,
        data: (user as AuthModel).toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to sign up. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Something went wrong with login: ${e.response?.data}');
    }
  }

  @override
  Future<Either> register(AuthEntity user) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.register,
        data: (user as AuthModel).toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to sign up. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Something went wrong with login: ${e.response?.data}');
    }
  }
}
