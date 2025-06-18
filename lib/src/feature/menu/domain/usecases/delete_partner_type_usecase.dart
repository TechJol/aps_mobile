import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class DeletePartnerTypeUsecase {
  final MenuRepository repository;

  DeletePartnerTypeUsecase({required this.repository});

  Future<Either> call(int id) async {
    return await repository.deletePartnerType(id);
  }
}
