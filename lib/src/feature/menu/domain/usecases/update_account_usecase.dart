import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class UpdateAccountUsecase {
  final MenuRepository repository;

  UpdateAccountUsecase({required this.repository});

  Future<Either> call(AccountModel account, int id) async {
    return await repository.updateAccount(account, id);
  }
}
