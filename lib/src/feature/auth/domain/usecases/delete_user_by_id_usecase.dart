import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class DeleteUserByIdUsecase {
  final AuthRepository repository;

  DeleteUserByIdUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) {
    return repository.deleteUserById(id);
  }
}
