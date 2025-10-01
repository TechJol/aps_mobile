class OperationFilter {
  const OperationFilter({this.periodLabel, this.startDate, this.endDate});

  final String? periodLabel;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get hasCustomRange => startDate != null && endDate != null;
  bool get isEmpty => periodLabel == null && !hasCustomRange;

  OperationFilter copyWith({
    String? periodLabel,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return OperationFilter(
      periodLabel: periodLabel ?? this.periodLabel,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  String formattedLabel() {
    if (periodLabel != null) return periodLabel!;
    if (hasCustomRange) {
      final start = _formatDate(startDate!);
      final end = _formatDate(endDate!);
      return '$start - $end';
    }
    return '';
  }

  static String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}
