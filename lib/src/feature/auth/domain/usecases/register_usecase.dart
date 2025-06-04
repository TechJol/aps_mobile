import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class RegisterUsecase {
  final AuthRepository authRepository;

  RegisterUsecase({required this.authRepository});

  Future<Either> call(AuthEntity user) async =>
      await authRepository.register(user);
}
