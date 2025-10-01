import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/account/presentation/widgets/account_balances.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class CurrencyBreakdown extends StatelessWidget {
  const CurrencyBreakdown({
    super.key,
    required this.totals,
    required this.formatAmount,
  });

  final List<CurrencyTotal> totals;
  final String Function(Decimal amount, String? currency) formatAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          totals
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.currency,
                        style: AppTextStyles.f14w500.copyWith(
                          color: AppColors.greyColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        formatAmount(item.amount, item.currency),
                        style: AppTextStyles.f16w600.copyWith(
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
