import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryReportsPage extends StatelessWidget {
  const CategoryReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Отчеты по статьям',
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuTransactionsWithAccountsSuccess) {
            final incomeData = _calculateTop6Reasons(
              state.transactions,
              state.reasons,
              type: 'income',
            );

            final expenseData = _calculateTop6Reasons(
              state.transactions,
              state.reasons,
              type: 'expense',
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  20.h,
                  ButtonsRow(),
                  20.h,
                  MonthsTabs(),
                  20.h,
                  TitleSection(title: 'Основные статьи , доход'),
                  20.h,
                  PieChartSection(data: incomeData),
                  20.h,
                  LegendSection(data: incomeData),
                  40.h,
                  DataTableSection(data: incomeData),
                  40.h,
                  TitleSection(title: 'Основные статьи , расход'),
                  20.h,
                  PieChartSection(data: expenseData),
                  20.h,
                  LegendSection(data: expenseData),
                  40.h,
                  DataTableSection(data: expenseData),
                  40.h,
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Map<String, dynamic>> _calculateTop6Reasons(
    List<AllTransactionsModel> transactions,
    List<IncomeExpenseReasons> reasons, {
    required String type,
  }) {
    final Map<int, Decimal> totals = {};

    for (var tx in transactions) {
      if (tx.transactionType == type && tx.incomeExpenseReason != null) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
        totals[tx.incomeExpenseReason!] =
            (totals[tx.incomeExpenseReason!] ?? Decimal.zero) + amount;
      }
    }

    final sorted =
        totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final totalAmount = sorted.fold<Decimal>(
      Decimal.zero,
      (prev, e) => prev + e.value,
    );

    // final Decimal hundred = Decimal.fromInt(100);

    return sorted.take(6).map((entry) {
      final reason = reasons.firstWhere(
        (r) => r.id == entry.key,
        orElse:
            () => IncomeExpenseReasons(
              id: entry.key,
              name: 'Без названия',
              type: type,
              company: null,
            ),
      );

      return {
        'name': reason.name,
        'amount': entry.value.toString(),
        'percent': totalAmount.toDouble(),
      };
    }).toList();
  }
}

class ButtonsRow extends StatelessWidget {
  const ButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButtonWidget(text: 'Распечатать', onPressed: () {}),
        SizedBox(width: 12),
        OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
      ],
    );
  }
}

class MonthsTabs extends StatelessWidget {
  const MonthsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            months
                .map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      m,
                      style: AppTextStyles.f12w400.copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.f16w500);
  }
}

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.8,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: MediaQuery.of(context).size.width * 0.16,
          sections:
              data.asMap().entries.map((entry) {
                final color = _chartColors[entry.key % _chartColors.length];
                final percent = entry.value['percent'] ?? 0.0;
                return PieChartSectionData(
                  color: color,
                  value: percent,
                  title: '${percent.toStringAsFixed(0)}%',
                  radius: MediaQuery.of(context).size.width * 0.2,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class LegendSection extends StatelessWidget {
  const LegendSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          data.asMap().entries.map((entry) {
            final color = _chartColors[entry.key % _chartColors.length];
            return LegendItem(color: color, text: entry.value['name']);
          }).toList(),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 16, height: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.f14w500),
        ],
      ),
    );
  }
}

class DataTableSection extends StatelessWidget {
  const DataTableSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        headingRowColor: WidgetStateProperty.all(AppColors.primaryColorLight),
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.white),
        columns: const [
          DataColumn(label: Text('№')),
          DataColumn(label: Text('Статья')),
          DataColumn(label: Text('Сумма (сом)')),
          DataColumn(label: Text('Процент')),
        ],
        rows:
            data.asMap().entries.map((entry) {
              final row = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${entry.key + 1}')),
                  DataCell(Text(row['name'] ?? '')),
                  DataCell(Text(row['amount'] ?? '')),
                  DataCell(
                    Text('${(row['percent'] ?? 0.0).toStringAsFixed(0)}%'),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

const List<Color> _chartColors = [
  Color(0xFF7B37B5),
  Color(0xFFF219A2),
  Color(0xFF156CB1),
  Color(0xFFCCC9AA),
  Color(0xFF1EBF93),
  Color(0xFFFCA12C),
];
