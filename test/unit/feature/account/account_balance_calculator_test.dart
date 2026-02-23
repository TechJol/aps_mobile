import 'package:aps_mobile/src/feature/income/data/models/account_model.dart';
import 'package:aps_mobile/src/feature/menu/data/models/all_transactions_model.dart';
import 'package:aps_mobile/src/feature/account/presentation/widgets/account_balances.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

AllTransactionsModel tx({
  required int id,
  required int account,
  required String currency,
  required String amount,
  required String type,
  String? kgs,
}) {
  return AllTransactionsModel(
    id: id,
    currency: currency,
    date: '2026-01-10T10:00:00Z',
    amount: amount,
    transactionType: type,
    kgsCurrencyAmount: kgs,
    account: account,
    incomeExpenseReason: 1,
  );
}

void main() {
  test('AccountBalanceCalculator summary calculates totals and balances', () {
    final calc = AccountBalanceCalculator(rates: {'USD': 87.0, 'KGS': 1.0});

    final accounts = [
      AccountModel(
        id: 1,
        name: 'Main KGS',
        accountType: 'cash',
        currency: 'KGS',
      ),
      AccountModel(
        id: 2,
        name: 'Main USD',
        accountType: 'bank',
        currency: 'USD',
      ),
    ];

    final transactions = [
      tx(id: 1, account: 1, currency: 'KGS', amount: '1000', type: 'income'),
      tx(id: 2, account: 1, currency: 'KGS', amount: '400', type: 'expense'),
      tx(
        id: 3,
        account: 2,
        currency: 'USD',
        amount: '50',
        type: 'income',
        kgs: '4350',
      ),
      tx(
        id: 4,
        account: 2,
        currency: 'USD',
        amount: '10',
        type: 'expense',
        kgs: '870',
      ),
    ];

    final summary = calc.summary(
      accounts: accounts,
      transactions: transactions,
    );

    expect(summary.totalKgs, Decimal.parse('4080'));
    expect(summary.balances.first.amount, Decimal.parse('600'));
    expect(summary.balances.last.amount, Decimal.parse('40'));

    final kgsTotal = summary.currencyTotals.firstWhere(
      (e) => e.currency == 'KGS',
    );
    final usdTotal = summary.currencyTotals.firstWhere(
      (e) => e.currency == 'USD',
    );
    expect(kgsTotal.amount, Decimal.parse('600'));
    expect(usdTotal.amount, Decimal.parse('40'));
  });
}
