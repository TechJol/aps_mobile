// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

/// Сервис проверки и запуска обновлений с Google Play (Android).
class InAppUpdateService {
  /// Проверка наличия обновления.
  /// [immediate] = true — «жёсткое» обновление (блокирует UI до установки).
  /// [immediate] = false — «гибкое» (пользователь может продолжать пользоваться).
  static Future<void> checkAndPrompt({
    required BuildContext context,
    bool immediate = false,
  }) async {
    if (kIsWeb) {
      debugPrint('InAppUpdate skipped: web platform');
      return;
    }

    if (defaultTargetPlatform != TargetPlatform.android) {
      debugPrint('InAppUpdate skipped: not running on Android');
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'InAppUpdate skipped: debug build does not support Play updates',
      );
      return;
    }

    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (immediate) {
          await InAppUpdate.performImmediateUpdate(); // приложение перезапустится
          return;
        }
        await _startFlexibleFlow(context);
      }
    } catch (e) {
      debugPrint('InAppUpdate error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось проверить обновление')),
        );
      }
    }
  }

  static Future<void> _startFlexibleFlow(BuildContext context) async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      if (!context.mounted) return;

      final approve = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder:
            (ctx) => AlertDialog(
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
}
