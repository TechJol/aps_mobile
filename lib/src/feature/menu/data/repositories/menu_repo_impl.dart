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
}
