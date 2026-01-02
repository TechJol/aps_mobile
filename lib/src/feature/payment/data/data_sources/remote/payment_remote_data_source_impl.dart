import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> getPlans() async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        AppApi.plans,
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
          'Failed to get plans. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    } catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg));
    }
  }

  @override
  Future<Either> getPeriods() async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        AppApi.periods,
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
          'Failed to get periods. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    } catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg));
    }
  }

  @override
  Future<Either> startPayment({
    required int planId,
    required int periodId,
  }) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().post(
        AppApi.paymentStart,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'fi0b25V9IEeulV5AoTdUL3JSAaP4YZDP',
          },
        ),
        data: {
          'plan_id': planId,
          'period_id': periodId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to start payment. Status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return await AuthError(dio: dio).handleUnauthorized();
      }
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    } catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg));
    }
  }
}
