import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountOverviewView extends StatelessWidget {
  const AccountOverviewView({
    super.key,
    required this.summary,
    required this.isRatesLoading,
    required this.onAddAccount,
    required this.onOpenAccount,
  });

  final AccountSummary summary;
  final bool isRatesLoading;
  final VoidCallback onAddAccount;
  final ValueChanged<AccountModel> onOpenAccount;

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '',
      decimalDigits: 2,
    );

    String formatAmount(Decimal amount, String? currency) =>
        formatNumericAmountWithCurrency(
          double.tryParse(amount.toString()) ?? 0,
          currency,
          formatter: formatter,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          30.h,
          AccountBalanceHeader(
            isLoading: isRatesLoading,
            totalAmountText: formatAmount(summary.totalKgs, 'KGS'),
            onAddAccount: onAddAccount,
          ),
          if (summary.currencyTotals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: CurrencyBreakdown(
                totals: summary.currencyTotals,
                formatAmount: formatAmount,
              ),
            ),
          24.h,
          if (summary.hasAccounts)
            AccountCardsList(
              balances: summary.balances,
              formatAmount: formatAmount,
              onOpenAccount: onOpenAccount,
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(
                  t.account.account.errors.accountNotFound,
                  style: AppTextStyles.f16w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
