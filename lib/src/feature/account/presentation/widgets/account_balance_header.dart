import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AccountBalanceHeader extends StatelessWidget {
  const AccountBalanceHeader({
    super.key,
    required this.isLoading,
    required this.totalAmountText,
    required this.onAddAccount,
  });

  final bool isLoading;
  final String totalAmountText;
  final VoidCallback onAddAccount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text(
                totalAmountText,
                style: AppTextStyles.f24w600.copyWith(fontFamily: 'Inter'),
              ),
            Text(
              t.account.totalBalances,
              style: AppTextStyles.f14w500.copyWith(
                color: AppColors.greyColor,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(140, 48)),
          onPressed: onAddAccount,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.account.addAccount,
                style: AppTextStyles.f16w500.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.add, size: 20, color: AppColors.blackColor),
            ],
          ),
        ),
      ],
    );
  }
}
