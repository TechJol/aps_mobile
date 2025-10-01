import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';

class TransactionGroup {
  const TransactionGroup({required this.label, required this.items});

  final String label;
  final List<AllTransactionsModel> items;
}

class OperationTransactionsHelper {
  static List<AllTransactionsModel> filterByRange({
    required List<AllTransactionsModel> transactions,
    String? periodLabel,
    DateTime? startDate,
    DateTime? endDate,
    required DateTime Function() nowBuilder,
    required String weekLabel,
    required String oneMonthLabel,
    required String threeMonthLabel,
  }) {
    DateTime? start;
    DateTime? end;
    final now = nowBuilder();

    if (periodLabel != null) {
      if (periodLabel == weekLabel) {
        start = now.subtract(const Duration(days: 7));
        end = now;
      } else if (periodLabel == oneMonthLabel) {
        start = DateTime(now.year, now.month - 1, now.day);
        end = now;
      } else if (periodLabel == threeMonthLabel) {
        start = DateTime(now.year, now.month - 3, now.day);
        end = now;
      }
    }

    if (startDate != null && endDate != null) {
      start = startDate;
      end = endDate;
    }

    if (start == null || end == null) {
      return List<AllTransactionsModel>.from(transactions);
    }

    return transactions.where((tx) {
      final date = DateTime.tryParse(tx.date ?? '');
      if (date == null) return false;
      return date.isAfter(start!.subtract(const Duration(days: 1))) &&
          date.isBefore(end!.add(const Duration(days: 1)));
    }).toList();
  }

  static List<TransactionGroup> groupByDate(
    List<AllTransactionsModel> transactions,
  ) {
    final sorted = List<AllTransactionsModel>.from(transactions)..sort((a, b) {
      final aDate = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final bDate = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return bDate.compareTo(aDate);
    });

    final Map<String, List<AllTransactionsModel>> grouped = {};

    for (final tx in sorted) {
      final date = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
      final label =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(tx);
    }

    return grouped.entries
        .map((entry) => TransactionGroup(label: entry.key, items: entry.value))
        .toList();
  }

  static Decimal amountInKgs(
    AllTransactionsModel tx,
    Map<String, double> rates,
  ) {
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
