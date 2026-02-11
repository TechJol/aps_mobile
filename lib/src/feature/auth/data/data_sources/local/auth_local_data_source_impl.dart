import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<bool> isLoggedIn() async {
    final storage = await SharedPreferences.getInstance();
    final accessToken = storage.getString('accessToken');
    return accessToken != null;
  }

  @override
  Future<Either<Object, bool>> logOut() async {
    final storage = await SharedPreferences.getInstance();

    final appLocale = storage.getString('app_locale');

    await storage.remove('accessToken');
    await storage.remove('refreshToken');
    await storage.remove('userId');
    await storage.remove('companyId');

    if (appLocale != null) {
      await storage.setString('app_locale', appLocale);
    }

    return const Right(true);
  }

  @override
  Future<void> saveUserMeta({int? userId, int? companyId}) async {
    final storage = await SharedPreferences.getInstance();
    if (companyId != null) {
      await storage.setInt('companyId', companyId);
    }
    if (userId != null) {
      await storage.setInt('userId', userId);
    }
  }

  @override
  Future<int?> getUserId() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getInt('userId');
  }

  @override
  Future<int?> getCompanyId() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getInt('companyId');
  }
}
