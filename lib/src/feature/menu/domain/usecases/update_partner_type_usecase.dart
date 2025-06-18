import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class UpdatePartnerTypeUsecase {
  UpdatePartnerTypeUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(PartnerTypesModel partner, int id) async {
    return await repository.updatePartnerType(partner, id);
  }
}
