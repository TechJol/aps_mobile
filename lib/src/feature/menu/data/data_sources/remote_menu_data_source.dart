import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class RemoteMenuDataSource {
  Future<Either> getTransactions();

  Future<Either> updateTransaction(AllTransactionsModel transaction, int id);

  Future<Either> deleteTransaction(int id);

  Future<Either> getPartners();

  Future<Either> deletePartner(int id);

  Future<Either> postPartner(PartnersModel partner);

  Future<Either> updatePartner(PartnersModel partner, int id);

  Future<Either> getPartnerTypes();

  Future<Either> postPartnerType(PartnerTypesModel partner);

  Future<Either> deletePartnerType(int id);

  Future<Either> updatePartnerType(PartnerTypesModel partner, int id);

  Future<Either> getAccounts();

  Future<Either> postAccount(AccountModel account);

  Future<Either> deleteAccount(int id);

  Future<Either> updateAccount(AccountModel account, int id);

  Future<Either> getReasons();

  Future<Either> postReason(IncomeExpenseReasons reasons);

  Future<Either> deleteReason(int id);

  Future<Either> updateReason(IncomeExpenseReasons reasons, int id);
}
