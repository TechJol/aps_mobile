import 'package:aps_mobile/src/feature/menu/data/models/all_transactions_model.dart';
import 'package:aps_mobile/src/feature/operation/presentation/widgets/transaction_group.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

AllTransactionsModel tx({
  int? id,
  required String date,
  required String amount,
  required String currency,
  required String type,
  String? kgsAmount,
}) {
  return AllTransactionsModel(
    id: id,
    currency: currency,
    date: date,
    amount: amount,
    kgsCurrencyAmount: kgsAmount,
    transactionType: type,
    account: 1,
    incomeExpenseReason: 1,
  );
}

void main() {
  group('OperationTransactionsHelper.filterByRange', () {
    test('filters by week period', () {
      final items = [
        tx(
          id: 1,
          date: '2026-02-20T10:00:00Z',
          amount: '100',
          currency: 'KGS',
          type: 'income',
        ),
        tx(
          id: 2,
          date: '2026-02-10T10:00:00Z',
          amount: '100',
          currency: 'KGS',
          type: 'income',
        ),
      ];

      final result = OperationTransactionsHelper.filterByRange(
        transactions: items,
        periodLabel: 'week',
        startDate: null,
        endDate: null,
        nowBuilder: () => DateTime.parse('2026-02-23T12:00:00Z'),
        weekLabel: 'week',
        oneMonthLabel: 'month',
        threeMonthLabel: '3month',
      );

      expect(result.map((e) => e.id), [1]);
    });

    test('custom range overrides period label', () {
      final items = [
        tx(
          id: 1,
          date: '2026-01-05T10:00:00Z',
          amount: '100',
          currency: 'KGS',
          type: 'income',
        ),
        tx(
          id: 2,
          date: '2026-03-05T10:00:00Z',
          amount: '100',
          currency: 'KGS',
          type: 'income',
        ),
      ];

      final result = OperationTransactionsHelper.filterByRange(
        transactions: items,
        periodLabel: 'week',
        startDate: DateTime.parse('2026-03-01T00:00:00Z'),
        endDate: DateTime.parse('2026-03-31T23:59:59Z'),
        nowBuilder: DateTime.now,
        weekLabel: 'week',
        oneMonthLabel: 'month',
        threeMonthLabel: '3month',
      );

      expect(result.map((e) => e.id), [2]);
    });
  });

  group('OperationTransactionsHelper.groupByDate', () {
    test('groups by dd.MM.yyyy and keeps descending date order', () {
      final items = [
        tx(
          id: 1,
          date: '2026-01-10T08:00:00Z',
          amount: '1',
          currency: 'KGS',
          type: 'income',
        ),
        tx(
          id: 2,
          date: '2026-01-11T08:00:00Z',
          amount: '1',
          currency: 'KGS',
          type: 'income',
        ),
        tx(
          id: 3,
          date: '2026-01-10T12:00:00Z',
          amount: '1',
          currency: 'KGS',
          type: 'income',
        ),
      ];

      final grouped = OperationTransactionsHelper.groupByDate(items);

      expect(grouped.first.label, '11.01.2026');
      expect(grouped.last.label, '10.01.2026');
      expect(grouped.last.items.length, 2);
    });
  });

  group('OperationTransactionsHelper.amountInKgs', () {
    test('returns cached KGS amount when provided', () {
      final item = tx(
        id: 1,
        date: '2026-01-01T00:00:00Z',
        amount: '100',
        currency: 'USD',
        type: 'income',
        kgsAmount: '9500',
      );

      final result = OperationTransactionsHelper.amountInKgs(item, {
        'USD': 87.0,
      });
      expect(result, Decimal.parse('9500'));
    });

    test('converts by rate when cached KGS amount absent', () {
      final item = tx(
        id: 1,
        date: '2026-01-01T00:00:00Z',
        amount: '100',
        currency: 'USD',
        type: 'income',
      );

      final result = OperationTransactionsHelper.amountInKgs(item, {
        'USD': 87.0,
      });
      expect(result, Decimal.parse('8700.0'));
    });
  });
}
