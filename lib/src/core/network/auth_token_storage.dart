import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorage {
  // final _storage = const FlutterSecureStorage();
  final sheredPref = SharedPreferences.getInstance();

  // Сохраняем токены
  Future<void> saveTokens(String access, String refresh) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    log("Saving tokens----- Access Token: $access, Refresh Token: $refresh");
    await storage.setString('accessToken', access);
    await storage.setString('refreshToken', refresh);
  }

  // Получаем токен доступа
  Future<String?> getAccessToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    return accessToken;
  }

  // Получаем refresh токен
  Future<String?> getRefreshToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var refreshToken = storage.getString('refreshToken');
    return refreshToken;
  }

  Future<void> clearTokens() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.remove('accessToken');
    await storage.remove('refreshToken');
    log("Tokens cleared!"); // Логируем очистку токенов
  }
}
