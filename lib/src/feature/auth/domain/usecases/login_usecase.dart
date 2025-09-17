import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/auth/domain/entities/auth_session.dart';
import 'package:aps_mobile/src/feature/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  Future<Either<Failure, AuthSession>> call({
    required String username,
    required String password,
  }) async => await authRepository.login(username, password);
}
