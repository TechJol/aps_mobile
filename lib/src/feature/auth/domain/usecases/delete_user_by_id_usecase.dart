import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class DeleteUserByIdUsecase {
  final AuthRepository repository;

  DeleteUserByIdUsecase({required this.repository});

  Future<Either> call(int id) {
    return repository.deleteUserById(id);
  }
}
