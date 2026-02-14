// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upgrade_version/flutter_upgrade_version.dart';

/// Сервис проверки и запуска обновлений из магазинов приложений.
class InAppUpdateService {
  /// Проверка наличия обновления.
  /// [immediate] = true — «жёсткое» обновление (блокирует UI до установки).
  /// [immediate] = false — «гибкое» (пользователь может продолжать пользоваться).
  static Future<void> checkAndPrompt({
    required BuildContext context,
    bool immediate = false,
  }) async {
    if (kIsWeb) {
      debugPrint('Update check skipped: web platform');
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _checkAndroidUpdate(immediate: immediate);
    }
  }

  static Future<void> _checkAndroidUpdate({required bool immediate}) async {
    try {
      final manager = InAppUpdateManager();
      final info = await manager.checkForUpdate();
      if (info == null || info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }

      if (immediate && info.immediateAllowed) {
        await manager.startAnUpdate(type: AppUpdateType.immediate);
        return;
      }

      if (info.flexibleAllowed) {
        await manager.startAnUpdate(type: AppUpdateType.flexible);
        return;
      }

      if (info.immediateAllowed) {
        await manager.startAnUpdate(type: AppUpdateType.immediate);
      }
    } catch (e) {
      debugPrint('Android in-app update error: $e');
    }
  }
}
