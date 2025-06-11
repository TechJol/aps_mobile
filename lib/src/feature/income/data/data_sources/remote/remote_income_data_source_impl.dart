import 'dart:developer';

import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteIncomeDataSourceImpl implements RemoteIncomeDataSource {
  RemoteIncomeDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> addIncomeExpense(IncomeAndComeoutModel income) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    var companyId = storage.getInt('companyId');

    log(companyId.toString());
    try {
      final response = await sl<DioClient>().post(
        AppApi.postTransactions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
        data: income.toJson()..['company'] = companyId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to post income. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> getAccount() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    try {
      final response = await sl<DioClient>().get(
        AppApi.getAccount,
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
          'Failed to get account. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> getIncomeExpenseReasons() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    try {
      final response = await sl<DioClient>().get(
        AppApi.getIncomeExpenseReasons,
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
          'Failed to get account. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }
}
