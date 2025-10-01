import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class AccountCardsList extends StatelessWidget {
  const AccountCardsList({
    super.key,
    required this.balances,
    required this.formatAmount,
    required this.onOpenAccount,
  });

  final List<AccountBalance> balances;
  final String Function(Decimal amount, String? currency) formatAmount;
  final ValueChanged<AccountModel> onOpenAccount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: balances.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final balance = balances[index];
        final account = balance.account;

        final gradients =
            index.isEven
                ? const [
                  Color(0xFF783BE0),
                  Color(0xFF8657F5),
                  Color(0xFF492BAB),
                  Color(0xFF462BA0),
                  Color(0xFF27175A),
                ]
                : const [
                  Color.fromARGB(255, 6, 34, 105),
                  Color(0xFF0A0AC8),
                  Color(0xFF0A0AC8),
                  Color.fromARGB(255, 25, 25, 185),
                  Color.fromARGB(255, 11, 29, 117),
                ];

        return CardWidget(
          onTap: () => onOpenAccount(account),
          price: formatAmount(balance.amount, account.currency),
          office: account.name,
          cardColor: gradients,
          currency: (account.currency ?? 'KGS').toUpperCase(),
        );
      },
    );
  }
}
