// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:intl/intl.dart'; // <— добавлено для форматирования оси Y

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

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

                        final rows =
                            yearlyData.map((row) {
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
                        final rows =
                            yearlyData.map((row) {
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

    const yearW = 100.0;
    const incomeW = 160.0;
    const expenseW = 160.0;
    const balanceW = 180.0;

    const gridColor = Color(0xFFE6E6E6);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalW = yearW + incomeW + expenseW + balanceW + 16 * 2 * 4;
        final minWidth =
            totalW < constraints.maxWidth ? constraints.maxWidth : totalW;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: Table(
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(yearW),
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
                    _cell(t.menu.metrics.year, isHeader: true),
                    _cell(t.menu.metrics.incomeKgz, isHeader: true),
                    _cell(t.menu.metrics.expenseKgz, isHeader: true),
                    _cell(t.menu.metrics.netIncomeKgz, isHeader: true),
                  ],
                ),
                ...yearlyData.map((row) {
                  return TableRow(
                    children: [
                      _cell(row['year'].toString()),
                      _cell(
                        row['income'].toString(),
                        color: AppColors.greenColor,
                      ),
                      _cell(
                        row['expense'].toString(),
                        color: AppColors.redColor,
                      ),
                      _cell(
                        row['balance'].toString(),
                        color: AppColors.greenColor,
                      ),
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

  /// === НОВЫЙ график с «умной» осью Y (как в Monthly report) ===
  Widget _buildGraphic() {
    const double barWidth = 170;
    const double groupSpacing = 20;

    final List<String> years =
        yearlyData.map((e) => e['year'].toString()).toList();
    final List<double> values =
        yearlyData.map((e) {
          final income =
              Decimal.tryParse(e['income'].toString()) ?? Decimal.zero;
          return income.toDouble();
        }).toList();

    // Автоподбор красивого максимума и шага
    final double rawMax =
        values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;
    final double niceMax = _niceCeil(rawMax * 1.15); // +15% запас сверху
    final double tickStep = _niceStep(niceMax, targetTicks: 6);

    // Компактное форматирование по текущей локали
    final locale = Localizations.localeOf(context).languageCode;
    final compact = NumberFormat.compact(locale: locale);

    final colors = const [
      Color(0xFF7B37B5),
      Color(0xFFF219A2),
      Color(0xFF156CB1),
      Color(0xFFCCC9AA),
      Color(0xFF1EBF93),
      Color(0xFFFCA12C),
    ];

    double chartWidth =
        years.length * barWidth + (years.length - 1) * groupSpacing + 40;

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
                    toY: values[index],
                    color: colors[index % colors.length],
                    width: barWidth,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: tickStep,
              getDrawingHorizontalLine:
                  (_) => const FlLine(color: Color(0xFFEAEAEA), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < years.length) {
                      return Text(years[index]);
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

  // === Вспомогательные функции для красивых делений оси Y ===
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

  void _prepareData(List<AllTransactionsModel> transactions) {
    final Map<String, Map<String, Decimal>> grouped = {};

    for (final tx in transactions) {
      final date = tx.date;
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final type = tx.transactionType;
      if (date == null || type == null) continue;

      final year = date.substring(0, 4);

      grouped.putIfAbsent(
        year,
        () => {'income': Decimal.zero, 'expense': Decimal.zero},
      );

      if (type == 'income') {
        grouped[year]!['income'] = grouped[year]!['income']! + amount;
      } else if (type == 'expense') {
        grouped[year]!['expense'] = grouped[year]!['expense']! + amount;
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
