// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:aps_mobile/src/core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:intl/intl.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

const String _kgs = 'KGS';

class _MetricsPageState extends State<MetricsPage> {
  List<Map<String, dynamic>> yearlyData = [];

  @override
  void initState() {
    super.initState();
    final menuCubit = context.read<MenuCubit>();
    if (menuCubit.state is! MenuTransactionsWithAccountsSuccess) {
      menuCubit.getTransactionsWithAccounts();
    } else {
      _prepareData(
        (menuCubit.state as MenuTransactionsWithAccountsSuccess).transactions,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasYearlyData = yearlyData.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.metrics.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuTransactionsWithAccountsSuccess) {
            _prepareData(state.transactions);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              20.h,
              if (hasYearlyData)
                Row(
                  children: [
                    OutlinedButtonWidget(
                      text: t.menu.common.print,
                      onPressed: () {
                        final headers = [
                          t.menu.metrics.year,
                          t.menu.metrics.incomeKgz,
                          t.menu.metrics.expenseKgz,
                          t.menu.metrics.netIncomeKgz,
                        ];

                        final rows = yearlyData.map((row) {
                          return [
                            row['year'].toString(),
                            row['income'].toString(),
                            row['expense'].toString(),
                            row['balance'].toString(),
                          ];
                        }).toList();

                        LocalService().printReportAsPdf(
                          context: context,
                          title: t.menu.metrics.yearlyReportTitle,
                          headers: headers,
                          rows: rows,
                        );
                      },
                    ),
                    12.w,
                    OutlinedButtonWidget(
                      text: t.menu.common.export,
                      onPressed: () {
                        final headers = [
                          t.menu.metrics.year,
                          t.menu.metrics.incomeKgz,
                          t.menu.metrics.expenseKgz,
                          t.menu.metrics.netIncomeKgz,
                        ];
                        final rows = yearlyData.map((row) {
                          return [
                            row['year'].toString(),
                            row['income'].toString(),
                            row['expense'].toString(),
                            row['balance'].toString(),
                          ];
                        }).toList();

                        LocalService().exportToExcelGeneric(
                          fileName: t.menu.metrics.yearlyReportFilename,
                          headers: headers,
                          rows: rows,
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              20.h,
              if (hasYearlyData)
                DropDownFormField(
                  items: [t.menu.metrics.byYears],
                  label: t.menu.metrics.selectPeriod,
                  value: t.menu.metrics.byYears,
                  onChanged: (value) {},
                ),
              40.h,
              if (hasYearlyData)
                Text(t.menu.metrics.tableTitle, style: AppTextStyles.f16w500),
              20.h,
              if (hasYearlyData) _buildMetrics(),
              60.h,
              if (hasYearlyData)
                Text(t.menu.metrics.chartTitle, style: AppTextStyles.f16w500),
              30.h,
              if (hasYearlyData)
                _buildGraphic()
              else
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text(t.menu.noData, style: AppTextStyles.f16w500),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    if (yearlyData.isEmpty) return const SizedBox.shrink();

    final headers = [
      t.menu.metrics.year,
      t.menu.metrics.incomeKgz,
      t.menu.metrics.expenseKgz,
      t.menu.metrics.netIncomeKgz,
    ];

    final rows = yearlyData.map((row) {
      return [
        row['year'].toString(),
        row['income'].toString(),
        row['expense'].toString(),
        row['balance'].toString(),
      ];
    }).toList();

    return ReportTableWidget(
      headers: headers,
      rows: rows,
      columnWidths: const [100, 160, 160, 180],
    );
  }

  Widget _buildGraphic() {
    const double barWidth = 34;
    const double groupSpacing = 28;
    const double barSpace = 6;

    final List<String> years = yearlyData
        .map((e) => e['year'].toString())
        .toList();
    final List<double> incomes = yearlyData
        .map(
          (e) => (Decimal.tryParse(e['income'].toString()) ?? Decimal.zero)
              .toDouble(),
        )
        .toList();
    final List<double> expenses = yearlyData
        .map(
          (e) => (Decimal.tryParse(e['expense'].toString()) ?? Decimal.zero)
              .toDouble(),
        )
        .toList();

    final double rawMax = [
      ...incomes,
      ...expenses,
    ].fold<double>(0, (maxVal, v) => v > maxVal ? v : maxVal);
    final double niceMax = _niceCeil((rawMax.abs()) * 1.15);
    final double tickStep = _niceStep(niceMax, targetTicks: 6);

    final locale = Localizations.localeOf(context).languageCode;
    final compact = NumberFormat.compact(locale: locale);

    const incomeColor = Color(0xFF5DBB6A);
    const expenseColor = Color(0xFFEB6B6B);

    double chartWidth =
        years.length * (barWidth * 2 + barSpace) +
        (years.length - 1) * groupSpacing +
        60;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: 400,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: niceMax > 0 ? niceMax : 1,
            groupsSpace: groupSpacing,
            barGroups: List.generate(years.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: incomes[index],
                    color: incomeColor,
                    width: barWidth,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  BarChartRodData(
                    toY: expenses[index],
                    color: expenseColor,
                    width: barWidth,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
                barsSpace: barSpace,
              );
            }),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: tickStep,
              verticalInterval: 1,
              checkToShowVerticalLine: (_) => true,
              getDrawingHorizontalLine: (_) =>
                  const FlLine(color: Color(0xFFE0E0E0), strokeWidth: 1),
              getDrawingVerticalLine: (_) =>
                  const FlLine(color: Color(0xFFE0E0E0), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < years.length) {
                      return Text(years[index], textAlign: TextAlign.center);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: tickStep,
                  reservedSize: 60,
                  getTitlesWidget: (value, _) => Text(compact.format(value)),
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
    final candidates = [1, 2, 5, 10].map((m) => m * base).toList()
      ..sort((a, b) => (a - raw).abs().compareTo((b - raw).abs()));
    return candidates.first.toDouble();
  }

  void _prepareData(List<AllTransactionsModel> transactions) {
    final Map<String, Map<String, Decimal>> grouped = {};

    for (final tx in transactions) {
      final isKgs = (tx.currency ?? '').toUpperCase() == _kgs;
      if (!isKgs) continue;

      final dateStr = tx.date;
      final type = tx.transactionType;
      if (dateStr == null || type == null) continue;

      final dt = DateTime.tryParse(dateStr);
      final year = dt != null ? dt.year.toString() : dateStr.substring(0, 4);

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      grouped.putIfAbsent(
        year,
        () => {'income': Decimal.zero, 'expense': Decimal.zero},
      );

      if (type == 'income') {
        grouped[year]!['income'] = grouped[year]!['income']! + amount;
      } else if (type == 'expense') {
        grouped[year]!['expense'] = grouped[year]!['expense']! + amount;
        // если расходы у тебя приходят со знаком "-", используй:
        // grouped[year]!['expense'] = grouped[year]!['expense']! + amount.abs();
      }
    }

    final List<Map<String, dynamic>> result = [];
    grouped.forEach((year, data) {
      final income = data['income'] ?? Decimal.zero;
      final expense = data['expense'] ?? Decimal.zero;
      final balance = income - expense;

      result.add({
        'year': year,
        'income': income,
        'expense': expense,
        'balance': balance,
      });
    });

    setState(() {
      yearlyData = result;
    });
  }
}
