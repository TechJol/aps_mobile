import 'dart:math';
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

const String _kgs = 'KGS';

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  final LocalService _localService = LocalService();
  String _selectedMonth = DateTime.now().month.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.monthlyReport.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuError) {
              return Center(child: Text(state.message));
            }

            if (state is MenuTransactionsWithAccountsSuccess) {
              final transactions = state.transactions;
              final reasons = state.reasons;

              final tableData = _calculateMonthlyData(
                transactions,
                _selectedMonth,
              );

              final chartData = _buildChartData(
                transactions,
                reasons,
                _selectedMonth,
              );

              // ✅ легенда только по фактическим данным (после фильтра KGS)
              final legendData = _buildLegend(chartData, reasons);

              final hasData = tableData.isNotEmpty;

              return ListView(
                children: [
                  20.h,
                  _ActionButtons(
                    localService: _localService,
                    selectedMonth: _selectedMonth,
                    tableData: tableData,
                  ),
                  20.h,
                  _MonthsTabs(
                    selectedMonth: _selectedMonth,
                    onMonthSelected: (m) => setState(() => _selectedMonth = m),
                  ),
                  20.h,
                  hasData
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle(text: t.menu.monthlyReport.title),
                          20.h,
                          _ChartSection(data: chartData, reasons: reasons),
                          20.h,
                          _LegendList(legendData: legendData),
                          40.h,
                          _MonthlyDataTable(data: tableData),
                        ],
                      )
                      : const _NoDataStub(),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// График: учитываем только KGS
  Map<int, Map<int, Decimal>> _buildChartData(
    List<AllTransactionsModel> transactions,
    List<IncomeExpenseReasons> reasons,
    String month,
  ) {
    final Map<int, Map<int, Decimal>> chartData = {};

    for (final tx in transactions) {
      if (tx.date == null || tx.incomeExpenseReason == null) continue;

      final date = DateTime.tryParse(tx.date!);
      if (date == null || date.month.toString() != month) continue;

      // ✅ только сомовые транзакции
      final isKgs = (tx.currency ?? '').toUpperCase() == _kgs;
      if (!isKgs) continue;

      final day = date.day;
      final reasonId = tx.incomeExpenseReason!;
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      chartData.putIfAbsent(day, () => {});
      chartData[day]![reasonId] =
          (chartData[day]![reasonId] ?? Decimal.zero) + amount;
    }

    return chartData;
  }
}

/// Таблица: Доход/Расход/Чистый доход только по KGS
List<Map<String, String>> _calculateMonthlyData(
  List<AllTransactionsModel> transactions,
  String month,
) {
  Decimal income = Decimal.zero;
  Decimal expense = Decimal.zero;

  for (final tx in transactions) {
    if (tx.date == null) continue;

    final sameMonth = DateTime.parse(tx.date!).month.toString() == month;
    if (!sameMonth) continue;

    // ✅ только сомовые транзакции
    final isKgs = (tx.currency ?? '').toUpperCase() == _kgs;
    if (!isKgs) continue;

    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

    if (tx.transactionType == 'income') {
      income += amount;
    } else if (tx.transactionType == 'expense') {
      expense += amount; // если расходы со знаком "-", используй amount.abs()
    }
  }

  if (income == Decimal.zero && expense == Decimal.zero) {
    return [];
  }

  final balance = income - expense;

  return [
    {
      'month': '2025-$month',
      'income': income.toString(),
      'expense': expense.toString(),
      'balance': balance.toString(),
    },
  ];
}

/// Легенда только для статей, реально присутствующих в chartData
List<Map<String, String>> _buildLegend(
  Map<int, Map<int, Decimal>> chartData,
  List<IncomeExpenseReasons> reasons,
) {
  // id причин, попавших на график
  final presentIds = <int>{};
  for (final dayMap in chartData.values) {
    presentIds.addAll(dayMap.keys);
  }

  // та же палитра, что в графике (приведём к строке для _LegendItem)
  final List<String> colors = [
    '0xFF7B37B5',
    '0xFFF219A2',
    '0xFF156CB1',
    '0xFFCCC9AA',
    '0xFF1EBF93',
    '0xFFFCA12C',
  ];

  // фиксируем сопоставление reasonId -> индекс (как в графике)
  final reasonIdToIndex = {
    for (var i = 0; i < reasons.length; i++) reasons[i].id!: i,
  };

  // только присутствующие причины + правильный цвет
  return reasons.where((r) => r.id != null && presentIds.contains(r.id)).map((
    r,
  ) {
    final idx = reasonIdToIndex[r.id] ?? 0;
    return {'name': r.name, 'color': colors[idx % colors.length]};
  }).toList();
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.localService,
    required this.selectedMonth,
    required this.tableData,
  });

  final LocalService localService;
  final String selectedMonth;
  final List<Map<String, String>> tableData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButtonWidget(
          text: t.menu.common.print,
          onPressed: () {
            final headers = [
              t.menu.monthlyReport.table.month,
              t.menu.monthlyReport.table.income,
              t.menu.monthlyReport.table.expense,
              t.menu.monthlyReport.table.balance,
            ];
            final rows =
                tableData
                    .map(
                      (row) => [
                        row['month'] ?? '',
                        row['income'] ?? '',
                        row['expense'] ?? '',
                        row['balance'] ?? '',
                      ],
                    )
                    .toList();

            localService.printReportAsPdf(
              context: context,
              title: '${t.menu.monthlyReport.filenamePrefix}$selectedMonth',
              headers: headers,
              rows: rows,
            );
          },
        ),
        const SizedBox(width: 12),
        OutlinedButtonWidget(
          text: t.menu.common.export,
          onPressed: () {
            final headers = [
              t.menu.monthlyReport.table.month,
              t.menu.monthlyReport.table.income,
              t.menu.monthlyReport.table.expense,
              t.menu.monthlyReport.table.balance,
            ];
            final rows =
                tableData
                    .map(
                      (row) => [
                        row['month']!,
                        row['income']!,
                        row['expense']!,
                        row['balance']!,
                      ],
                    )
                    .toList();

            localService.exportToExcelGeneric(
              fileName: '${t.menu.monthlyReport.filenamePrefix}$selectedMonth',
              headers: headers,
              rows: rows,
              context: context,
            );
          },
        ),
      ],
    );
  }
}

class _MonthsTabs extends StatelessWidget {
  const _MonthsTabs({
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final String selectedMonth;
  final ValueChanged<String> onMonthSelected;

  @override
  Widget build(BuildContext context) {
    final months = [
      t.menu.months.january,
      t.menu.months.february,
      t.menu.months.march,
      t.menu.months.april,
      t.menu.months.may,
      t.menu.months.june,
      t.menu.months.july,
      t.menu.months.august,
      t.menu.months.september,
      t.menu.months.october,
      t.menu.months.november,
      t.menu.months.december,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            months.asMap().entries.map((entry) {
              final monthNumber = (entry.key + 1).toString();
              final isSelected = monthNumber == selectedMonth;

              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => onMonthSelected(monthNumber),
                  child: Text(
                    entry.value,
                    style: AppTextStyles.f12w400.copyWith(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.f16w500);
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.data, required this.reasons});

  final Map<int, Map<int, Decimal>> data;
  final List<IncomeExpenseReasons> reasons;

  @override
  Widget build(BuildContext context) {
    return MonthlyReportChart(data: data, reasons: reasons);
  }
}

class _LegendList extends StatelessWidget {
  const _LegendList({required this.legendData});

  final List<Map<String, String>> legendData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          legendData
              .map(
                (item) =>
                    _LegendItem(color: item['color']!, text: item['name']!),
              )
              .toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.text});
  final String color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 16, height: 16, color: Color(int.parse(color))),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.f14w500),
        ],
      ),
    );
  }
}

class _MonthlyDataTable extends StatelessWidget {
  const _MonthlyDataTable({required this.data});
  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    const monthW = 120.0;
    const incomeW = 160.0;
    const expenseW = 160.0;
    const balanceW = 180.0;

    const gridColor = Color(0xFFE6E6E6);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalW = monthW + incomeW + expenseW + balanceW + 16 * 2 * 4;
        final minWidth =
            totalW < constraints.maxWidth ? constraints.maxWidth : totalW;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Table(
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(monthW),
                1: FixedColumnWidth(incomeW),
                2: FixedColumnWidth(expenseW),
                3: FixedColumnWidth(balanceW),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColorLight,
                  ),
                  children: [
                    _cell(t.menu.monthlyReport.table.month, isHeader: true),
                    _cell(t.menu.monthlyReport.table.income, isHeader: true),
                    _cell(t.menu.monthlyReport.table.expense, isHeader: true),
                    _cell(t.menu.monthlyReport.table.balance, isHeader: true),
                  ],
                ),
                ...data.map((row) {
                  return TableRow(
                    children: [
                      _cell(row['month'] ?? ''),
                      _cell(row['income'] ?? '', color: AppColors.greenColor),
                      _cell(row['expense'] ?? '', color: AppColors.redColor),
                      _cell(row['balance'] ?? '', color: AppColors.greenColor),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cell(String text, {bool isHeader = false, Color? color}) {
    final style =
        isHeader
            ? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
            : AppTextStyles.f16w500.copyWith(
              color: color ?? AppColors.blackColor,
            );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _NoDataStub extends StatelessWidget {
  const _NoDataStub();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text(t.menu.common.noDataForSelectedMonth),
      ),
    );
  }
}

class MonthlyReportChart extends StatelessWidget {
  final Map<int, Map<int, Decimal>> data;
  final List<IncomeExpenseReasons> reasons;

  const MonthlyReportChart({
    super.key,
    required this.data,
    required this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    final reasonColors = _reasonColors();
    final reasonIdToIndex = {
      for (var i = 0; i < reasons.length; i++) reasons[i].id!: i,
    };

    final List<BarChartGroupData> barGroups = [];
    double maxDaySum = 0;

    final sortedDays = data.keys.toList()..sort();
    for (final day in sortedDays) {
      final segments = data[day] ?? const {};

      double sum = 0;
      final rods = <BarChartRodStackItem>[];

      final segEntries =
          segments.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
      for (final seg in segEntries) {
        final reasonIndex = reasonIdToIndex[seg.key] ?? 0;
        final color = reasonColors[reasonIndex % reasonColors.length];

        final start = sum;
        sum += seg.value.toDouble();
        rods.add(BarChartRodStackItem(start, sum, color));
      }

      if (sum > maxDaySum) maxDaySum = sum;

      barGroups.add(
        BarChartGroupData(
          x: day,
          barRods: [
            BarChartRodData(
              toY: sum,
              rodStackItems: rods,
              borderRadius: BorderRadius.circular(4),
              width: 16,
            ),
          ],
        ),
      );
    }

    final double niceMax = _niceCeil(maxDaySum * 1.15);
    final double tickStep = _niceStep(niceMax, targetTicks: 5);
    final compact = NumberFormat.compact(locale: 'ru');

    return SizedBox(
      height: 350,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: niceMax > 0 ? niceMax : 1,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameSize: 32,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) => Text(value.toInt().toString()),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: tickStep,
                reservedSize: 50,
                getTitlesWidget: (value, _) => Text(compact.format(value)),
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: tickStep,
            getDrawingHorizontalLine:
                (_) => const FlLine(color: Color(0xFFEAEAEA), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<Color> _reasonColors() => const [
    Color(0xFF7B37B5),
    Color(0xFFF219A2),
    Color(0xFF156CB1),
    Color(0xFFCCC9AA),
    Color(0xFF1EBF93),
    Color(0xFFFCA12C),
  ];

  double _niceCeil(double x) {
    if (x <= 0) return 1;
    final exp = (log(x) / ln10).floor();
    final base = pow(10, exp).toDouble();
    for (final m in [1, 2, 5, 10]) {
      final candidate = m * base;
      if (candidate >= x) return candidate.toDouble();
    }
    return 10 * base;
  }

  double _niceStep(double maxValue, {int targetTicks = 5}) {
    if (maxValue <= 0) return 1;
    final raw = maxValue / targetTicks;
    final exp = (log(raw) / ln10).floor();
    final base = pow(10, exp).toDouble();
    final candidates =
        [1, 2, 5, 10].map((m) => m * base).toList()
          ..sort((a, b) => (a - raw).abs().compareTo((b - raw).abs()));
    return candidates.first.toDouble();
  }
}
