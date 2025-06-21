import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RemoteIncomeDataSourceImpl implements RemoteIncomeDataSource {
  RemoteIncomeDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> addIncomeExpense(IncomeAndComeoutModel income) async {
    final accessToken = await AuthTokenStorage().getAccessToken();

    try {
      final response = await sl<DioClient>().post(
        AppApi.transactions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
        data: income.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to get transactions. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Обработка ошибки 401 (неверный или истёкший токен)
      if (e is DioException && e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> getAccount() async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        AppApi.account,
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
      // Обработка ошибки 401 (неверный или истёкший токен)
      if (e is DioException && e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }

  @override
  Future<Either> getIncomeExpenseReasons() async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        AppApi.reason,
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
      // Обработка ошибки 401 (неверный или истёкший токен)
      if (e is DioException && e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      return Left(Exception('Something went wrong: ${e.toString()}'));
    }
  }
}
