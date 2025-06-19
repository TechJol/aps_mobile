import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class UpdateReasonUsecase {
  UpdateReasonUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(IncomeExpenseReasons reasons, int id) async {
    return await repository.updateReason(reasons, id);
  }
}
