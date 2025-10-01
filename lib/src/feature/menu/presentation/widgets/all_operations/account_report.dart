import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';

class AccountReportRow {
  const AccountReportRow({
    required this.index,
    required this.account,
    required this.balance,
  });

  final int index;
  final AccountModel account;
  final Decimal balance;
}

class AccountCurrencyTotal {
  const AccountCurrencyTotal({required this.currency, required this.amount});

  final String currency;
  final Decimal amount;
}

class AccountReportSummary {
  const AccountReportSummary({
    required this.rows,
    required this.currencyTotals,
    required this.totalKgs,
  });

  final List<AccountReportRow> rows;
  final List<AccountCurrencyTotal> currencyTotals;
  final Decimal totalKgs;
}

class AccountReportCalculator {
  const AccountReportCalculator({required this.rates});

  final Map<String, double> rates;

  AccountReportSummary build({
    required List<AccountModel> accounts,
    required List<AllTransactionsModel> transactions,
  }) {
    final rows = <AccountReportRow>[];
    for (var i = 0; i < accounts.length; i++) {
      final account = accounts[i];
      final balance = _accountBalance(
        accountId: account.id,
        transactions: transactions,
      );
      rows.add(
        AccountReportRow(index: i + 1, account: account, balance: balance),
      );
    }

    final totalsByCurrency = _totalsByCurrency(transactions);
    for (final account in accounts) {
      final code = (account.currency ?? 'KGS').toUpperCase();
      totalsByCurrency.putIfAbsent(code, () => Decimal.zero);
    }

    final currencyTotals =
        _sortedCurrencies(totalsByCurrency.keys)
            .map(
              (code) => AccountCurrencyTotal(
                currency: code,
                amount: totalsByCurrency[code] ?? Decimal.zero,
              ),
            )
            .where((item) => item.amount != Decimal.zero)
            .toList();

    return AccountReportSummary(
      rows: rows,
      currencyTotals: currencyTotals,
      totalKgs: _totalBalance(transactions),
    );
  }

  Decimal _accountBalance({
    required int? accountId,
    required List<AllTransactionsModel> transactions,
  }) {
    if (accountId == null) return Decimal.zero;

    Decimal total = Decimal.zero;
    for (final tx in transactions) {
      if (tx.account != accountId) continue;
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }
    return total;
  }

  Map<String, Decimal> _totalsByCurrency(
    List<AllTransactionsModel> transactions,
  ) {
    final totals = <String, Decimal>{'KGS': Decimal.zero};
    for (final tx in transactions) {
      final currency = (tx.currency ?? 'KGS').toUpperCase();
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      totals.putIfAbsent(currency, () => Decimal.zero);
      if (tx.transactionType == 'income') {
        totals[currency] = totals[currency]! + amount;
      } else if (tx.transactionType == 'expense') {
        totals[currency] = totals[currency]! - amount;
      }
    }
    return totals;
  }

  Decimal _totalBalance(List<AllTransactionsModel> transactions) {
    Decimal total = Decimal.zero;
    for (final tx in transactions) {
      final amount = _amountInKgs(tx);
      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }
    return total;
  }

  Decimal _amountInKgs(AllTransactionsModel tx) {
    final currency = (tx.currency ?? 'KGS').toUpperCase();
    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
    if (currency == 'KGS') return amount;

    final cached = tx.kgsCurrencyAmount;
    if (cached != null && cached.trim().isNotEmpty) {
      return Decimal.tryParse(cached) ?? amount;
    }

    final rate = rates[currency];
    if (rate == null || rate == 0) return amount;

    return amount * Decimal.parse(rate.toString());
  }

  Iterable<String> _sortedCurrencies(Iterable<String> currencies) {
    const priority = ['KGS', 'USD', 'EUR', 'RUB'];
    final unique = currencies.map((e) => e.toUpperCase()).toSet();
    unique.addAll(priority);
    final list = unique.toList();
    list.sort((a, b) {
      final ia = priority.indexOf(a);
      final ib = priority.indexOf(b);
      if (ia != -1 && ib != -1) return ia.compareTo(ib);
      if (ia != -1) return -1;
      if (ib != -1) return 1;
      return a.compareTo(b);
    });
    return list;
  }
}
