import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ShowSheet {
  Future<void> showDeleteDialog(
    BuildContext context, {
    required String accountName,
    required void Function()? onConfirm,
    required String title,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // нельзя закрыть тапом вне окна
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: Text(title, style: AppTextStyles.f22w500),
          content: Text(
            'Вы уверены, что хотите удалить счет "$accountName"?',
            style: AppTextStyles.f16w500.copyWith(
              color: AppColors.greyerColorLight,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.backroundColor,
                      side: BorderSide(color: AppColors.backroundColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Отмена',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // закрыть диалог
                      if (onConfirm != null) onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Да',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
