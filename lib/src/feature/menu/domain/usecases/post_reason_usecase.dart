import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class PostReasonUsecase {
  PostReasonUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(IncomeExpenseReasons reasons) async {
    return await repository.postReason(reasons);
  }
}
