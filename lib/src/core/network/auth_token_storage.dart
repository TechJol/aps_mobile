import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorage {
  final _storage = const FlutterSecureStorage();

  // Сохраняем токены
  Future<void> saveTokens(String access, String refresh) async {
    print("Saving tokens: Access Token: $access, Refresh Token: $refresh");
    await _storage.write(key: 'access', value: access);
    await _storage.write(key: 'refresh', value: refresh);
  }

  // Получаем токен доступа
  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: 'access');
    print("Retrieved access token: $token"); // Логируем извлечённый токен
    return token;
  }

  // Получаем refresh токен
  Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: 'refresh');
    print(
      "Retrieved refresh token: $token",
    ); // Логируем извлечённый refresh токен
    return token;
  }

  // Очищаем токены
  Future<void> clearTokens() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
    print("Tokens cleared!"); // Логируем очистку токенов
  }
}
