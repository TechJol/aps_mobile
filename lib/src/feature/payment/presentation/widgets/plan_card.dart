import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.option, this.onTap});

  final PlanOption option;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = option.isSelected
        ? AppColors.primaryColorLight
        : option.highlight
            ? AppColors.primaryColorLight
            : AppColors.greyColorLight;
    final backgroundColor = option.highlight
        ? AppColors.nextbackColor
        : AppColors.whiteColor;

    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 1.4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option.title,
                          style: AppTextStyles.f14w600.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          option.subtitle,
                          style: AppTextStyles.f9w400.copyWith(
                            color: AppColors.smallTextGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        option.price,
                        style: AppTextStyles.f14w600.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      4.h,
                      Text(
                        'за период',
                        style: AppTextStyles.f12w400.copyWith(
                          color: AppColors.smallTextGreyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (option.badge != null)
          Positioned(
            right: 12,
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColorLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option.badge!,
                style: AppTextStyles.f12w600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
