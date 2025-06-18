import 'dart:developer';

import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RemoteMenuDataSourceImpl implements RemoteMenuDataSource {
  RemoteMenuDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> getTransactions() async {
    final accessToken = await AuthTokenStorage().getAccessToken();

    log("Access token used: $accessToken");

    try {
      final response = await sl<DioClient>().get(
        AppApi.transactions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
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
  Future<Either> getPartners() async {
    final accessToken = await AuthTokenStorage().getAccessToken();

    try {
      final response = await sl<DioClient>().get(
        AppApi.partners,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
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
  Future<Either> deletePartner(int id) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().delete(
        '${AppApi.partners}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to delete partner type. Status code: ${response.statusCode}',
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
  Future<Either> postPartner(PartnersModel partner) async {
    final accessToken = await AuthTokenStorage().getAccessToken();

    try {
      final response = await sl<DioClient>().post(
        AppApi.partners,

        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 204 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to post partner. Status code: ${response.statusCode}',
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
  Future<Either> updatePartner(PartnersModel partner, int id) async {
    final accessToken = await AuthTokenStorage().getAccessToken();

    try {
      final response = await sl<DioClient>().put(
        '${AppApi.partners}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to update partner. Status code: ${response.statusCode}',
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
  Future<Either> getPartnerTypes() async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().get(
        AppApi.partnerTypes,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to get partner types. Status code: ${response.statusCode}',
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
  Future<Either> deletePartnerType(int id) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().delete(
        '${AppApi.partnerTypes}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to delete partner type. Status code: ${response.statusCode}',
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
  Future<Either> postPartnerType(PartnerTypesModel partner) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().post(
        AppApi.partnerTypes,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to post partner type. Status code: ${response.statusCode}',
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
  Future<Either> updatePartnerType(PartnerTypesModel partner, int id) async {
    final accessToken = await AuthTokenStorage().getAccessToken();
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.partnerTypes}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return Right(response.data);
      } else {
        throw Exception(
          'Failed to update partner type. Status code: ${response.statusCode}',
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
