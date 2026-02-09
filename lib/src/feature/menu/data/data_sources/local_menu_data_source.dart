import 'package:aps_mobile/src/feature/feature.dart';

abstract class MenuLocalDataSource {
  Future<MenuCacheSnapshot?> getTransactionsSnapshot({required int companyId});
  Future<void> saveTransactionsSnapshot({
    required int companyId,
    required MenuCacheSnapshot snapshot,
  });
}
