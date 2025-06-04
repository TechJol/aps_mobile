import 'package:aps_mobile/src/feature/feature.dart';

class RegisterUsecase {
  final AuthRepository authRepository;

  RegisterUsecase({required this.authRepository});

  Future<void> call(AuthEntity user) async =>
      await authRepository.register(user);
}
