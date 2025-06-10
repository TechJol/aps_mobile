import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class AddIncomeUsecase {
  final IncomeRepository repository;
  AddIncomeUsecase({required this.repository});

  Future<Either> call(IncomeAndComeoutModel income) async =>
      await repository.addIncome(income);
}
