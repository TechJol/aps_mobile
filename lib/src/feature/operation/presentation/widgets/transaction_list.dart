import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class OperationTransactionList extends StatelessWidget {
  const OperationTransactionList({
    super.key,
    required this.groups,
    required this.partners,
    required this.controller,
    required this.onRequestPartner,
  });

  final List<TransactionGroup> groups;
  final List<PartnersModel> partners;
  final AnimationController controller;
  final Future<void> Function(AllTransactionsModel transaction)
  onRequestPartner;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(child: Text(t.operation.notOperation));
    }

    controller.forward(from: 0);
    int globalIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.operation.operation, style: AppTextStyles.f20w600),
          12.h,
          for (final group in groups)
            ...group.items.map((tx) {
              final begin = (globalIndex * 0.08).clamp(0.0, 0.92);
              globalIndex += 1;
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: controller,
                  curve: Interval(begin, 1.0, curve: Curves.easeOut),
                ),
                child: GestureDetector(
                  onTap: () => _handleTap(context, tx),
                  child: _OperationTransactionTile(
                    transaction: tx,
                    partners: partners,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _handleTap(
    BuildContext context,
    AllTransactionsModel transaction,
  ) async {
    if (transaction.partners != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.operation.hasPartner)));
      return;
    }
    await onRequestPartner(transaction);
  }
}

class _OperationTransactionTile extends StatelessWidget {
  const _OperationTransactionTile({
    required this.transaction,
    required this.partners,
  });

  final AllTransactionsModel transaction;
  final List<PartnersModel> partners;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.transactionType == 'income';
    final date = DateTime.tryParse(transaction.date ?? '') ?? DateTime.now();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
        ' - '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final formattedAmount = formatAmountWithCurrency(
      transaction.amount,
      transaction.currency,
    );
    final amountText =
        formattedAmount.isEmpty
            ? formattedAmount
            : (isIncome ? formattedAmount : '-$formattedAmount');

    final bgColor =
        isIncome ? const Color(0xFFDFF7E2) : const Color(0xFFF9DCDC);
    final arrowColor =
        isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445);
    final icon = isIncome ? Icons.call_received : Icons.north_west;

    final partnerName =
        partners
            .firstWhere(
              (p) => p.id == transaction.partners,
              orElse: () => PartnersModel(name: t.operation.plusPartner),
            )
            .name;
    final partnerStyle =
        partnerName == t.operation.plusPartner
            ? AppTextStyles.f14w500.copyWith(color: AppColors.primaryColor)
            : AppTextStyles.f14w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: arrowColor, size: 20),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(partnerName, style: partnerStyle),
                4.h,
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
