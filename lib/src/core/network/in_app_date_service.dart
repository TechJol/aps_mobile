// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/constants/app_update_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Сервис проверки и запуска обновлений из магазинов приложений.
class InAppUpdateService {
  static const _skipVersionKey = 'app_update_skipped_version';
  static const _skipTimestampKey = 'app_update_skipped_at';

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

    var handledByStore = false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      handledByStore = await _handleAndroidInAppUpdate(
        context: context,
        immediate: immediate,
      );
    }

    if (!handledByStore) {
      await _checkStoreVersion(context);
    }
  }

  static Future<void> _startFlexibleFlow(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      if (!context.mounted) return;

      final approve = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Доступно обновление'),
          content: const Text('Обновление загружено. Установить сейчас?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Позже'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Установить'),
            ),
          ],
        ),
      );

      if (approve == true) {
        await InAppUpdate.completeFlexibleUpdate(); // перезапустит приложение
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Обновление отложено')));
        }
      }
    } catch (e) {
      debugPrint('Flexible update error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось загрузить обновление')),
        );
      }
    }
  }

  static Future<bool> _handleAndroidInAppUpdate({
    required BuildContext context,
    required bool immediate,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return false;

    if (kDebugMode) {
      debugPrint(
        'InAppUpdate skipped: debug build does not support Play updates',
      );
      return false;
    }

    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return false;
      }

      if (immediate) {
        await InAppUpdate.performImmediateUpdate();
        return true;
      }
      await _startFlexibleFlow(context);
      return true;
    } catch (e) {
      debugPrint('InAppUpdate error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось проверить обновление')),
        );
      }
      return false;
    }
  }

  static Future<void> _checkStoreVersion(BuildContext context) async {
    try {
      final newVersion = NewVersionPlus(
        androidId: AppUpdateConfig.androidId,
        iOSId: AppUpdateConfig.iosId,
        iOSAppStoreCountry: AppUpdateConfig.iosAppStoreCountry,
        androidPlayStoreCountry: AppUpdateConfig.androidPlayStoreCountry,
      );

      final status = await newVersion.getVersionStatus();
      if (status == null || !status.canUpdate) return;

      final prefs = await SharedPreferences.getInstance();
      final skippedVersion = prefs.getString(_skipVersionKey);
      final skippedAtMs = prefs.getInt(_skipTimestampKey);

      if (skippedVersion == status.storeVersion && skippedAtMs != null) {
        final skippedAt = DateTime.fromMillisecondsSinceEpoch(skippedAtMs);
        if (DateTime.now().difference(skippedAt) <
            AppUpdateConfig.remindLaterInterval) {
          return;
        }
      }

      if (!context.mounted) return;

      final releaseNotes = status.releaseNotes?.trim();
      final message = (releaseNotes?.isNotEmpty ?? false)
          ? releaseNotes!
          : 'Доступна новая версия ${status.storeVersion}. Обновите приложение, чтобы получить последние улучшения.';

      final shouldUpdate = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Доступно обновление'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Позже'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Обновить'),
            ),
          ],
        ),
      );

      if (shouldUpdate == true) {
        final uri = Uri.parse(status.appStoreLink);
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Не удалось открыть магазин приложений'),
            ),
          );
        }
      } else if (shouldUpdate == false) {
        prefs
          ..setString(_skipVersionKey, status.storeVersion)
          ..setInt(_skipTimestampKey, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint('Store update check error: $e');
    }
  }
}
