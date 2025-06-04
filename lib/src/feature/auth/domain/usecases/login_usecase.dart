import 'package:aps_mobile/src/feature/auth/auth.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  Future<void> call(AuthEntity user) async => await authRepository.login(user);
}
