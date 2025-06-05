import 'package:aps_mobile/src/feature/feature.dart';

class IsLoggedInUsecase {
  final AuthRepository authRepository;

  IsLoggedInUsecase({required this.authRepository});

  Future<bool> call() async {
    return await authRepository.isLoggedIn();
  }
}
