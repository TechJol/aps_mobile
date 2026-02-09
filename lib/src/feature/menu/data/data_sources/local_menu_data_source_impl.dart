import 'dart:convert';

import 'package:aps_mobile/src/feature/feature.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  final SharedPreferences sharedPreferences;

  const MenuLocalDataSourceImpl({required this.sharedPreferences});

  String _key(int companyId) => 'menu_transactions_cache_$companyId';

  @override
  Future<MenuCacheSnapshot?> getTransactionsSnapshot({
    required int companyId,
  }) async {
    final raw = sharedPreferences.getString(_key(companyId));
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return MenuCacheSnapshot.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveTransactionsSnapshot({
    required int companyId,
    required MenuCacheSnapshot snapshot,
  }) async {
    await sharedPreferences.setString(_key(companyId), jsonEncode(snapshot.toMap()));
  }
}
