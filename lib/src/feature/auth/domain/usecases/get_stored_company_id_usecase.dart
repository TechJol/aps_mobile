import 'package:aps_mobile/src/feature/auth/domain/repositories/auth_repo.dart';

class GetStoredCompanyIdUsecase {
  const GetStoredCompanyIdUsecase({required this.repository});

  final AuthRepository repository;

  Future<int?> call() => repository.getStoredCompanyId();
}
