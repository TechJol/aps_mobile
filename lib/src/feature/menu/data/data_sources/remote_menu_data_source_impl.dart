import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteMenuDataSourceImpl implements RemoteMenuDataSource {
  RemoteMenuDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> getTransactions() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');

    try {
      final response = await sl<DioClient>().get(
        AppApi.transactions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to get transactions. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> getPartners() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');

    try {
      final response = await sl<DioClient>().get(
        AppApi.partners,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to get transactions. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> deletePartner(int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');

    try {
      final response = await sl<DioClient>().delete(
        '${AppApi.partners}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 204) {
        return const Right(true);
      } else {
        throw Exception(
          'Failed to delete partner. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Delete failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either> postPartner(PartnersModel partner) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');

    try {
      final response = await sl<DioClient>().post(
        AppApi.partners,

        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to post partner. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }
}
