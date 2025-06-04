import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  Future<Either> call(AuthEntity user) async =>
      await authRepository.login(user);
}
