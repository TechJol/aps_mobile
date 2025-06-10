import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class GetAccountUsecase {
  GetAccountUsecase({required this.repository});

  final IncomeRepository repository;

  Future<Either> call() async => await repository.getAccount();
}
