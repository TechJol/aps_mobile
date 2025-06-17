import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class RemoteMenuDataSource {
  Future<Either> getTransactions();

  Future<Either> getPartners();

  Future<Either> deletePartner(int id);

  Future<Either> postPartner(PartnersModel partner);

  Future<Either> updatePartner(PartnersModel partner, int id);
}
