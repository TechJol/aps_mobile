import 'package:aps_mobile/src/feature/operation/presentation/widgets/operation_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OperationFilter', () {
    test('isEmpty true when no period and no custom range', () {
      const filter = OperationFilter();
      expect(filter.isEmpty, isTrue);
      expect(filter.hasCustomRange, isFalse);
    });

    test('formattedLabel returns period label when set', () {
      const filter = OperationFilter(periodLabel: 'Week');
      expect(filter.formattedLabel(), 'Week');
    });

    test('formattedLabel returns date range when custom range is set', () {
      final filter = OperationFilter(
        startDate: DateTime(2026, 1, 3),
        endDate: DateTime(2026, 2, 7),
      );

      expect(filter.hasCustomRange, isTrue);
      expect(filter.formattedLabel(), '03.01.2026 - 07.02.2026');
    });
  });
}
