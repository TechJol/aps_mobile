import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopSection extends StatelessWidget {
  final MenuTransactionsWithAccountsSuccess? data;
  final PeriodType selectedPeriod;
  final List<PeriodType> periodOptions;
  final String Function(PeriodType) periodLabel;
  final void Function(PeriodType) onPeriodTap;
  final void Function(bool forward) onPeriodChange;

  const TopSection({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.periodLabel,
    required this.onPeriodTap,
    required this.onPeriodChange,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return SizedBox(height: 240, child: Text(t.home.noOperations));
    }

    final totals = _calculateIncomeExpenseTotals(
      transactions: data!.transactions,
      period: selectedPeriod,
    );

    final legendItems = [
      _LegendItemData(
        label: t.home.income,
        color: AppColors.greenColor50,
        value: totals.income,
      ),
      _LegendItemData(
        label: t.home.expenses,
        color: AppColors.redColor50,
        value: totals.expense,
      ),
    ];

    final chartItems = legendItems.where((item) => item.value > 0).toList();
    final chartData = {for (final item in chartItems) item.label: item.value};
    final colors = [for (final item in chartItems) item.color];

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 240,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      periodLabel(selectedPeriod),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final offset = Tween<Offset>(
                      begin: const Offset(0, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    );
                  },
                  child:
                      chartItems.isEmpty
                          ? SizedBox(
                            key: ValueKey('empty_$selectedPeriod'),
                            height: 140,
                            child: Center(
                              child: Text(
                                t.home.noData,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          : Row(
                            key: ValueKey(
                              'chart_${selectedPeriod.name}_${totals.income}_${totals.expense}',
                            ),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 112,
                                height: 112,
                                child: CustomPaint(
                                  size: const Size(112, 112),
                                  painter: PieChartDynamicPainter(
                                    data: chartData,
                                    colors: colors,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              _IncomeExpenseLegend(items: legendItems),
                            ],
                          ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      periodOptions.map((period) {
                        final isSelected = selectedPeriod == period;
                        return GestureDetector(
                          onTap: () => onPeriodTap(period),
                          child: Column(
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color:
                                      isSelected
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                ),
                                child: Text(periodLabel(period)),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                height: 2,
                                width: isSelected ? 24 : 0,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: _CircleIcon(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () => onPeriodChange(false),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: _CircleIcon(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () => onPeriodChange(true),
          ),
        ),
      ],
    );
  }

  ({double income, double expense}) _calculateIncomeExpenseTotals({
    required List<AllTransactionsModel> transactions,
    required PeriodType period,
  }) {
    final now = DateTime.now();
    double income = 0;
    double expense = 0;

    for (final tx in transactions) {
      final date = DateTime.tryParse(tx.date ?? '');
      if (date == null) continue;
      if (!_isInPeriod(date, now, period)) continue;

      final amount = double.tryParse(tx.amount ?? '0') ?? 0;
      if (tx.transactionType == 'income') {
        income += amount;
      } else if (tx.transactionType == 'expense') {
        expense += amount;
      }
    }

    return (income: income, expense: expense);
  }

  bool _isInPeriod(DateTime txDate, DateTime reference, PeriodType period) {
    switch (period) {
      case PeriodType.day:
        return txDate.year == reference.year &&
            txDate.month == reference.month &&
            txDate.day == reference.day;
      case PeriodType.week:
        final startOfWeek = reference.subtract(
          Duration(days: reference.weekday - 1),
        );
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return !txDate.isBefore(startOfWeek) && !txDate.isAfter(endOfWeek);
      case PeriodType.month:
        return txDate.year == reference.year && txDate.month == reference.month;
      case PeriodType.year:
        return txDate.year == reference.year;
    }
  }
}

class _IncomeExpenseLegend extends StatelessWidget {
  final List<_LegendItemData> items;

  const _IncomeExpenseLegend({required this.items});

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final numberFormatter = NumberFormat.decimalPattern(localeName);

    return Padding(
      padding: const EdgeInsets.only(top: 22, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: item.color, radius: 5.5),
                        const SizedBox(width: 6),
                        Text(
                          '${item.label}: ${numberFormatter.format(item.value)} с',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _LegendItemData {
  final String label;
  final Color color;
  final double value;

  const _LegendItemData({
    required this.label,
    required this.color,
    required this.value,
  });
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        padding: const EdgeInsets.all(5),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class PieChartDynamicPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  PieChartDynamicPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.5
          ..strokeCap = StrokeCap.round;

    final total = data.values.fold(0.0, (sum, value) => sum + value);
    if (total == 0) return;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gap = 0.27;
    double startAngle = 0.0;
    final segments = data.entries.toList();

    for (int i = 0; i < segments.length; i++) {
      final value = segments[i].value;
      final rawSweep = (value / total) * 2 * 3.14159;
      final sweepAngle = rawSweep > gap ? rawSweep - gap : rawSweep;

      paint.color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      startAngle += rawSweep;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
