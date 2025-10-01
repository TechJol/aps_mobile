import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentOperationsSection extends StatelessWidget {
  final ViewType selectedView;

  const RecentOperationsSection({super.key, required this.selectedView});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.home.operations, style: AppTextStyles.f20w600),
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.read<MainCubit>().change(4),
                  child: Text(
                    t.home.seeAll,
                    style: AppTextStyles.f14w500.copyWith(
                      color: AppColors.smallTextGreyColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.smallTextGreyColor,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 0.3, color: AppColors.smallTextGreyColor),
        const SizedBox(height: 12),
        BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuTransactionsWithAccountsSuccess) {
              final transactions = _filterByViewType(
                state.transactions,
                selectedView,
              );
              final partners = state.partners;

              if (transactions.isEmpty) {
                return Center(child: Text(t.home.noOperations));
              }

              return Column(
                children: List.generate(transactions.length, (index) {
                  final tx = transactions[index];
                  final isIncome = tx.transactionType == 'income';
                  final amountText = _formatAmount(
                    tx.amount,
                    tx.currency,
                    isIncome,
                  );

                  final date =
                      DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
                  final formattedDate =
                      '${date.day.toString().padLeft(2, '0')}.'
                      '${date.month.toString().padLeft(2, '0')}.'
                      '${date.year} - '
                      '${date.hour.toString().padLeft(2, '0')}:'
                      '${date.minute.toString().padLeft(2, '0')}';

                  final partnerName =
                      partners
                          .firstWhere(
                            (partner) => partner.id == tx.partners,
                            orElse: () => PartnersModel(name: t.home.unknown),
                          )
                          .name;

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400 + index * 100),
                    tween: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ),
                    curve: Curves.easeOut,
                    builder:
                        (context, offset, child) => Transform.translate(
                          offset: offset * 30,
                          child: Opacity(
                            opacity: 1.0 - offset.dy,
                            child: child,
                          ),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  isIncome
                                      ? AppColors.greenColorLight
                                      : AppColors.redColorLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isIncome ? Icons.call_received : Icons.north_west,
                              color:
                                  isIncome
                                      ? AppColors.greenColor50
                                      : AppColors.redColor50,
                              size: 20,
                            ),
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
                                  isIncome
                                      ? AppColors.greenColor50
                                      : AppColors.redColor50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }

            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  List<AllTransactionsModel> _filterByViewType(
    List<AllTransactionsModel> transactions,
    ViewType type,
  ) {
    final sorted = [...transactions]..sort((a, b) {
      final dateA = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    switch (type) {
      case ViewType.all:
        return sorted.take(3).toList();
      case ViewType.income:
        return sorted
            .where((tx) => tx.transactionType == 'income')
            .take(3)
            .toList();
      case ViewType.expense:
        return sorted
            .where((tx) => tx.transactionType == 'expense')
            .take(3)
            .toList();
    }
  }

  String _formatAmount(String? amount, String? currency, bool isIncome) {
    final formatted = formatAmountWithCurrency(amount, currency);
    if (formatted.isEmpty) return formatted;
    return isIncome ? formatted : '-$formatted';
  }
}
