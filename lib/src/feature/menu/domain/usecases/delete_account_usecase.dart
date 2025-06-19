import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class DeleteAccountUsecase {
  DeleteAccountUsecase({required this.repository});

  final MenuRepository repository;

  Future<Either> call(int id) async {
    return await repository.deleteAccount(id);
  }
}
