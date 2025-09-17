import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStorage {
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class AuthTokenStorage implements TokenStorage {
  // final _storage = const FlutterSecureStorage();
  // final sheredPref = SharedPreferences.getInstance();

  // Сохраняем токены
  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    log(
      "Saving tokens----- Access Token: $accessToken, Refresh Token: $refreshToken",
    );
    await storage.setString('accessToken', accessToken);
    await storage.setString('refreshToken', refreshToken);
  }

  // Получаем токен доступа
  @override
  Future<String?> getAccessToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    return accessToken;
  }

  // Получаем refresh токен
  @override
  Future<String?> getRefreshToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var refreshToken = storage.getString('refreshToken');
    return refreshToken;
  }

  @override
  Future<void> clearTokens() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.remove('accessToken');
    await storage.remove('refreshToken');
    log("Tokens cleared!"); // Логируем очистку токенов
  }
}
