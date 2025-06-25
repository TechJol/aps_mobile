import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Месячный отчет',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuTransactionsWithAccountsSuccess) {
              final transactions = state.transactions;
              final reasons = state.reasons;

              // Месячные агрегированные данные (доход, расход и чистый доход)
              final Map<String, Map<String, Decimal>> monthlyData = {};

              for (var tx in transactions) {
                final month = DateTime.parse(
                  tx.date!,
                ).toString().substring(0, 7); // Формат YYYY-MM
                final amount =
                    Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
                final type = tx.transactionType;

                if (!monthlyData.containsKey(month)) {
                  monthlyData[month] = {
                    'income': Decimal.zero,
                    'expense': Decimal.zero,
                    'balance': Decimal.zero,
                  };
                }

                if (type == 'income') {
                  monthlyData[month]?['income'] =
                      (monthlyData[month]?['income'] ?? Decimal.zero) + amount;
                } else if (type == 'expense') {
                  monthlyData[month]?['expense'] =
                      (monthlyData[month]?['expense'] ?? Decimal.zero) + amount;
                }
              }

              // Вычисляем чистый доход по каждому месяцу
              monthlyData.forEach((month, data) {
                data['balance'] = data['income']! - data['expense']!;
              });

              final data =
                  monthlyData.entries.map((entry) {
                    return {
                      'month': entry.key,
                      'income': entry.value['income'].toString(),
                      'expense': entry.value['expense'].toString(),
                      'balance': entry.value['balance'].toString(),
                    };
                  }).toList();

              // Получаем данные для динамической легенды
              final dynamicLegendData = _getLegendDataFromAPI(reasons);

              return ListView(
                children: [
                  20.h,
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        text: 'Распечатать',
                        onPressed: () {},
                      ),
                      SizedBox(width: 12),
                      OutlinedButtonWidget(
                        text: 'Скачать в Excel',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  20.h,
                  buildMonthsTabs(),
                  20.h,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Доход', style: AppTextStyles.f16w500),
                        20.h,
                        MonthlyReportChart(),
                        20.h,
                        // Динамическая легенда
                        _dynamicLegendSection(dynamicLegendData),
                      ],
                    ),
                  ),
                  40.h,
                  _dataTableSection(data),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Месячные табы
  Widget buildMonthsTabs() {
    final months = [
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

    List<Widget> monthWidgets = [];
    for (int i = 0; i < months.length; i++) {
      monthWidgets.add(
        Text(
          months[i],
          style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
        ),
      );
      if (i != months.length - 1) {
        monthWidgets.add(20.w);
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: monthWidgets,
      ),
    );
  }

  // Динамическая легенда
  _dynamicLegendSection(List<Map<String, String>> dynamicLegendData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          dynamicLegendData.map<Widget>((item) {
            return _legendItem(color: item['color']!, text: item['name']!);
          }).toList(),
    );
  }

  _legendItem({required String color, required String text}) {
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

  // Получить данные для динамической легенды
  List<Map<String, String>> _getLegendDataFromAPI(
    List<IncomeExpenseReasons> reasons,
  ) {
    final List<Map<String, String>> legendData = [];

    // Определение цветов, которые будут использованы в порядке
    final List<String> colors = [
      '0xFF7B37B5', // фиолетовый
      '0xFFF219A2', // розовый
      '0xFF156CB1', // синий
      '0xFFCCC9AA', // бежевый
      '0xFF1EBF93', // зеленый
      '0xFFFCA12C', // оранжевый
    ];

    for (var i = 0; i < reasons.length; i++) {
      // Применяем цвета по порядку для каждой статьи
      legendData.add({
        'name': reasons[i].name,
        'color': colors[i % colors.length], // цикличное применение цветов
      });
    }

    return legendData;
  }

  // Данные таблицы
  _dataTableSection(List<Map<String, String>> data) {
    final int rowsPerPage = 10;
    int currentPage = 1;

    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

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
          DataColumn(label: Text('Месяц')),
          DataColumn(label: Text('Доход (KGZ)')),
          DataColumn(label: Text('Расход (KGZ)')),
          DataColumn(label: Text('Чистый доход (KGZ)')),
        ],
        rows:
            paginatedData.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['month']!)),
                  DataCell(
                    Text(
                      row['income']!,
                      style: TextStyle(color: AppColors.greenColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['expense']!,
                      style: TextStyle(color: AppColors.redColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['balance']!,
                      style: TextStyle(color: AppColors.greenColor),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class MonthlyReportChart extends StatelessWidget {
  MonthlyReportChart({super.key});

  final List<String> days = [
    '4',
    '5',
    '6',
    '10',
    '12',
    '20',
    '22',
    '24',
    '28',
    '29',
  ];

  final List<List<double>> data = [
    [1000, 500, 800, 200, 900, 400],
    [0, 0, 0, 900, 0, 0],
    [1500, 500, 1000, 1200, 700, 400],
    [800, 700, 1000, 0, 1200, 300],
    [700, 900, 1500, 0, 0, 0],
    [1000, 1100, 900, 100, 1400, 100],
    [600, 400, 900, 300, 100, 100],
    [900, 0, 700, 400, 500, 0],
    [1000, 900, 800, 600, 0, 300],
    [500, 700, 900, 100, 0, 200],
  ];

  final List<Color> colors = [
    Color(0xFF7B37B5), // Открытие ИП — фиолетовый
    Color(0xFFF219A2), // Открытие ОсОО — розовый
    Color(0xFF156CB1), // Доход от продажи — синий
    Color(0xFFCCC9AA), // Гражданское дело — бежевый
    Color(0xFF1EBF93), // Инвестиции — зеленый
    Color(0xFFFCA12C), // Выручка — оранжевый
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: 9000,
              barTouchData: BarTouchData(enabled: true),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Color(0xFFEAEAEA));
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 2000,
                    reservedSize: 40,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTextStyles.f14w500,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < days.length) {
                        return Text(days[index]);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              barGroups: List.generate(days.length, (index) {
                final vals = data[index];
                double sum = 0;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: vals.reduce((a, b) => a + b),
                      rodStackItems: List.generate(vals.length, (i) {
                        final start = sum;
                        sum += vals[i];
                        return BarChartRodStackItem(start, sum, colors[i]);
                      }),
                      borderRadius: BorderRadius.circular(4),
                      width: 20,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
