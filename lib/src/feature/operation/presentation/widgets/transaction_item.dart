import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final AllTransactionsModel tx;
  final List<PartnersModel> partners;

  const TransactionItem({super.key, required this.tx, required this.partners});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = tx.transactionType == 'income';
    final DateTime date = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final formatted = formatAmountWithCurrency(tx.amount, tx.currency);
    final String amountText =
        formatted.isEmpty ? formatted : (isIncome ? formatted : '-$formatted');

    final Color bgColor = isIncome ? Color(0xFFDFF7E2) : Color(0xFFF9DCDC);
    final Color arrowColor = isIncome ? Color(0xFF56BC60) : Color(0xFFE85445);
    final IconData arrowIcon =
        isIncome ? Icons.call_received : Icons.north_west;

    final partnerName =
        partners
            .firstWhere(
              (p) => p.id == tx.partners,
              orElse: () => PartnersModel(name: 'Неизвестно'),
            )
            .name;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(arrowIcon, color: arrowColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(partnerName, style: AppTextStyles.f14w500),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: AppTextStyles.f12w400.copyWith(
                    color: AppColors.smallTextGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: AppTextStyles.f16w600.copyWith(
              color:
                  isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445),
            ),
          ),
        ],
      ),
    );
  }
}
