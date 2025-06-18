import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class GetPartnerTypesUsecase {
  GetPartnerTypesUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call() async => await repository.getPartnerTypes();
}
