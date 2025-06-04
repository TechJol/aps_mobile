import 'package:aps_mobile/src/feature/auth/auth.dart';

abstract class AuthRepository {
  Future<void> login(AuthEntity user);
  Future<void> register(AuthEntity user);
}
