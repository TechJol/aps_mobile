import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class MenuRepository {
  Future<Either> getTransactions();

  Future<Either> getPartners();

  Future<Either> deletePartner(int id);

  Future<Either> postPartner(PartnersModel partner);

  Future<Either> updatePartner(PartnersModel partner, int id);

  Future<Either> getPartnerTypes();

  Future<Either> postPartnerType(PartnerTypesModel partner);
}
