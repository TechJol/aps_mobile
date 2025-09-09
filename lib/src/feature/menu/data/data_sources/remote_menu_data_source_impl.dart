import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RemoteMenuDataSourceImpl implements RemoteMenuDataSource {
  RemoteMenuDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Either> getTransactions() async {
    try {
      final response = await sl<DioClient>().get(
        AppApi.transactions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
          Failure('Failed to get transactions', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> getPartners() async {
    try {
      final response = await sl<DioClient>().get(
        AppApi.partners,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
          Failure('Failed to get partners', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> deletePartner(int id) async {
    try {
      await sl<DioClient>().delete(
        '${AppApi.partners}$id/',
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );
      return const Right(unit);
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> postPartner(PartnersModel partner) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.partners,

        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 204 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to post partner', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> updatePartner(PartnersModel partner, int id) async {
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.partners}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to update partner', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> getPartnerTypes() async {
    try {
      final response = await sl<DioClient>().get(
        AppApi.partnerTypes,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
          Failure('Failed to get partner types', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> deletePartnerType(int id) async {
    try {
      await sl<DioClient>().delete(
        '${AppApi.partnerTypes}$id/',
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );
      return const Right(unit);
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> postPartnerType(PartnerTypesModel partner) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.partnerTypes,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to post partner type', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> updatePartnerType(PartnerTypesModel partner, int id) async {
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.partnerTypes}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: partner.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to update partner type', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> deleteAccount(int id) async {
    try {
      await sl<DioClient>().delete(
        '${AppApi.account}$id/',
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );
      return const Right(unit);
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> postAccount(AccountModel account) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.account,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: account.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to post account', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> updateAccount(AccountModel account, int id) async {
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.account}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: account.toMap(),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to update account', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = NetworkErrorMapper.toMessage(e);
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> getAccounts() async {
    try {
      final response = await sl<DioClient>().get(
        AppApi.account,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
          Failure('Failed to get accounts', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> deleteReason(int id) async {
    try {
      await sl<DioClient>().delete(
        '${AppApi.reason}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );
      return const Right(unit);
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Delete failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> getReasons() async {
    try {
      final response = await sl<DioClient>().get(
        AppApi.reason,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
          Failure('Failed to get reasons', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> postReason(IncomeExpenseReasons reasons) async {
    try {
      final response = await sl<DioClient>().post(
        AppApi.reason,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: reasons.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to post reason', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> updateReason(IncomeExpenseReasons reasons, int id) async {
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.reason}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: reasons.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to update reason', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }

  @override
  Future<Either> updateTransaction(
    AllTransactionsModel transaction,
    int id,
  ) async {
    try {
      final response = await sl<DioClient>().put(
        '${AppApi.transactions}$id/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-CSRFTOKEN': 'uelFJVVgrTDO43VmKZBl9yF18vO7AGVE',
          },
        ),
        data: transaction.toMap(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(unit);
      } else {
        return Left(
          Failure('Failed to update transaction', code: response.statusCode),
        );
      }
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      return Left(Failure(msg, code: e.response?.statusCode));
    }
  }
}
