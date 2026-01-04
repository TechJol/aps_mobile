// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class PaymentProcessingOverlay extends StatelessWidget {
  const PaymentProcessingOverlay({super.key, required this.secondsLeft});

  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.1),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Платеж успешно обработан',
                style: AppTextStyles.f14w600.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              8.h,
              Text(
                'Мы вернем вас на главную страницу через $secondsLeft секунд',
                textAlign: TextAlign.center,
                style: AppTextStyles.f12w400.copyWith(
                  color: AppColors.smallTextGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
