import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class PostAccountUsecase {
  PostAccountUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(AccountModel account) async {
    return await repository.postAccount(account);
  }
}
