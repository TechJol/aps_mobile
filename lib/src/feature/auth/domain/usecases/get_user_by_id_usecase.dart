import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class GetUserByIdUsecase {
  GetUserByIdUsecase({required this.authRepository});

  final AuthRepository authRepository;

  Future<Either> call(int id) async => await authRepository.getUserById(id);
}
