import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class UpdatePartnerUsecase {
  UpdatePartnerUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(PartnersModel partner) async {
    return await repository.updatePartner(partner);
  }
}
