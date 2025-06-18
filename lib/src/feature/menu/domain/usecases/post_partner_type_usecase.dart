import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class PostPartnerTypeUsecase {
  PostPartnerTypeUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(PartnerTypesModel partner) async {
    return await repository.postPartnerType(partner);
  }
}
