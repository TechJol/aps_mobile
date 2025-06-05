import 'package:aps_mobile/src/feature/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<bool> isLoggedIn() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var accessToken = storage.getString('accessToken');
    if (accessToken == null) return false;
    return true;
  }

  @override
  Future<Either> logOut() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
    return const Right(true);
  }
}
