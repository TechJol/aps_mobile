import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class UpdateTransactionUsecase {
  UpdateTransactionUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(AllTransactionsModel transaction, int id) async {
    return await repository.updateTransaction(transaction, id);
  }
}
