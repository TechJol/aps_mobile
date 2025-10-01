import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';

class AccountSummary {
  final List<AccountModel> accounts;
  final List<AllTransactionsModel> transactions;
  final Decimal totalKgs;
  final List<CurrencyTotal> currencyTotals;
  final List<AccountBalance> balances;

  const AccountSummary({
    required this.accounts,
    required this.transactions,
    required this.totalKgs,
    required this.currencyTotals,
    required this.balances,
  });

  bool get hasAccounts => accounts.isNotEmpty;
}

class AccountBalance {
  final AccountModel account;
  final Decimal amount;

  const AccountBalance({required this.account, required this.amount});
}

class CurrencyTotal {
  final String currency;
  final Decimal amount;

  const CurrencyTotal({required this.currency, required this.amount});
}

class AccountBalanceCalculator {
  AccountBalanceCalculator({required Map<String, double> rates})
    : rates = {
        for (final entry in rates.entries) entry.key.toUpperCase(): entry.value,
      };

  final Map<String, double> rates;

  AccountSummary summary({
    required List<AccountModel> accounts,
    required List<AllTransactionsModel> transactions,
  }) {
    final totalsByCurrency = _calculateTotalsByCurrency(transactions);
    for (final account in accounts) {
      final currency = (account.currency ?? 'KGS').toUpperCase();
      totalsByCurrency.putIfAbsent(currency, () => Decimal.zero);
    }

    final balances =
        accounts
            .map(
              (account) => AccountBalance(
                account: account,
                amount: _calculateAccountBalanceInCurrency(
                  accountId: account.id,
                  accountCurrency: account.currency,
                  transactions: transactions,
                ),
              ),
            )
            .toList();

    final currencyTotals =
        _sortedCurrencies(totalsByCurrency)
            .map(
              (currency) => CurrencyTotal(
                currency: currency,
                amount: totalsByCurrency[currency] ?? Decimal.zero,
              ),
            )
            .toList();

    return AccountSummary(
      accounts: accounts,
      transactions: transactions,
      totalKgs: _calculateTotalBalanceKgs(transactions),
      currencyTotals: currencyTotals,
      balances: balances,
    );
  }

  Decimal _calculateTotalBalanceKgs(List<AllTransactionsModel> transactions) {
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

  Decimal _calculateAccountBalanceInCurrency({
    required int? accountId,
    required String? accountCurrency,
    required List<AllTransactionsModel> transactions,
  }) {
    if (accountId == null) return Decimal.zero;

    final currency = (accountCurrency ?? 'KGS').toUpperCase();
    Decimal total = Decimal.zero;

    for (final tx in transactions) {
      final sameAccount = tx.account == accountId;
      final sameCurrency = (tx.currency ?? '').toUpperCase() == currency;
      if (!sameAccount || !sameCurrency) continue;

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }
    return total;
  }

  Map<String, Decimal> _calculateTotalsByCurrency(
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

  Iterable<String> _sortedCurrencies(Map<String, Decimal> totals) {
    const preferredOrder = ['KGS', 'USD', 'EUR', 'RUB'];
    final currencies = totals.keys.map((e) => e.toUpperCase()).toSet();
    final sorted =
        currencies.toList()..sort((a, b) {
          final indexA = preferredOrder.indexOf(a);
          final indexB = preferredOrder.indexOf(b);
          if (indexA != -1 && indexB != -1) return indexA.compareTo(indexB);
          if (indexA != -1) return -1;
          if (indexB != -1) return 1;
          return a.compareTo(b);
        });
    return sorted;
  }

  Decimal _amountInKgs(AllTransactionsModel tx) {
    final currency = (tx.currency ?? 'KGS').toUpperCase();
    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

    if (currency == 'KGS') {
      return amount;
    }

    final cached = tx.kgsCurrencyAmount;
    if (cached != null && cached.trim().isNotEmpty) {
      return Decimal.tryParse(cached) ?? amount;
    }

    final rate = rates[currency];
    if (rate == null || rate == 0) {
      return amount;
    }

    return amount * Decimal.parse(rate.toString());
  }
}
