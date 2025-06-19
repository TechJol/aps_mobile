import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl({required this.remoteMenuDataSource});

  final RemoteMenuDataSource remoteMenuDataSource;

  @override
  Future<Either> getTransactions() async {
    return await remoteMenuDataSource.getTransactions();
  }

  @override
  Future<Either> getPartners() async {
    return await remoteMenuDataSource.getPartners();
  }

  @override
  Future<Either> deletePartner(int id) async {
    return await remoteMenuDataSource.deletePartner(id);
  }

  @override
  Future<Either> postPartner(PartnersModel partner) async {
    return await remoteMenuDataSource.postPartner(partner);
  }

  @override
  Future<Either> updatePartner(PartnersModel partner, int id) async {
    return await remoteMenuDataSource.updatePartner(partner, id);
  }

  @override
  Future<Either> getPartnerTypes() async {
    return await remoteMenuDataSource.getPartnerTypes();
  }

  @override
  Future<Either> deletePartnerType(int id) async {
    return await remoteMenuDataSource.deletePartnerType(id);
  }

  @override
  Future<Either> postPartnerType(PartnerTypesModel partner) async {
    return await remoteMenuDataSource.postPartnerType(partner);
  }

  @override
  Future<Either> updatePartnerType(PartnerTypesModel partner, int id) async {
    return await remoteMenuDataSource.updatePartnerType(partner, id);
  }

  @override
  Future<Either> deleteAccount(int id) async {
    return await remoteMenuDataSource.deleteAccount(id);
  }

  @override
  Future<Either> postAccount(AccountModel account) async {
    return await remoteMenuDataSource.postAccount(account);
  }

  @override
  Future<Either> updateAccount(AccountModel account, int id) async {
    return await remoteMenuDataSource.updateAccount(account, id);
  }

  @override
  Future<Either> getAccounts() async {
    return await remoteMenuDataSource.getAccounts();
  }

  @override
  Future<Either> deleteReason(int id) async {
    return await remoteMenuDataSource.deleteReason(id);
  }

  @override
  Future<Either> getReasons() async {
    return await remoteMenuDataSource.getReasons();
  }

  @override
  Future<Either> postReason(IncomeExpenseReasons reasons) async {
    return await remoteMenuDataSource.postReason(reasons);
  }

  @override
  Future<Either> updateReason(IncomeExpenseReasons reasons, int id) async {
    return await remoteMenuDataSource.updateReason(reasons, id);
  }
}
