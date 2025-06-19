import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class DeleteReasonUsecase {
  DeleteReasonUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(int id) async => await repository.deleteReason(id);
}
