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
}
