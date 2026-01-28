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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        final balanceBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  totalAmountText,
                  style: AppTextStyles.f20w600.copyWith(fontFamily: 'Inter'),
                ),
              ),
            Text(
              t.account.totalBalances,
              style: AppTextStyles.f14w500.copyWith(
                color: AppColors.greyColor,
                fontFamily: 'Inter',
              ),
            ),
          ],
        );

        final addButton = OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onPressed: onAddAccount,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.account.addAccount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.f16w500.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              8.w,
              const Icon(Icons.add, size: 20, color: AppColors.blackColor),
            ],
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [balanceBlock, const SizedBox(height: 12), addButton],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: balanceBlock),
            12.w,
            Flexible(child: addButton),
          ],
        );
      },
    );
  }
}
