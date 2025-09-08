import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class GetUserByIdUsecase {
  GetUserByIdUsecase({required this.authRepository});

  final AuthRepository authRepository;

  Future<Either<Failure, AuthEntity>> call(int id) async =>
      await authRepository.getUserById(id);
}
