import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  final LocalService localService = LocalService();
  String selectedMonth = '6';

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

              final data = _calculateMonthlyData(transactions, selectedMonth);

              final hasData = data.isNotEmpty;

              final dynamicLegendData = _getLegendDataFromAPI(reasons);

              return ListView(
                children: [
                  20.h,
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        text: 'Распечатать',
                        onPressed: () {
                          final headers = [
                            'Месяц',
                            'Доход (KGZ)',
                            'Расход (KGZ)',
                            'Чистый доход (KGZ)',
                          ];

                          final rows =
                              data.map((row) {
                                return [
                                  row['month'] ?? '',
                                  row['income'] ?? '',
                                  row['expense'] ?? '',
                                  row['balance'] ?? '',
                                ];
                              }).toList();

                          localService.printReportAsPdf(
                            context: context,
                            title: 'Месячный отчет за месяц $selectedMonth',
                            headers: headers,
                            rows: rows,
                          );
                        },
                      ),

                      const SizedBox(width: 12),
                      OutlinedButtonWidget(
                        text: 'Скачать в Excel',
                        onPressed: () {
                          final headers = [
                            'Месяц',
                            'Доход (KGZ)',
                            'Расход (KGZ)',
                            'Чистый доход (KGZ)',
                          ];
                          final rows =
                              data
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
                            fileName: 'Месячный_отчет_$selectedMonth',
                            headers: headers,
                            rows: rows,
                            context: context,
                          );
                        },
                      ),
                    ],
                  ),
                  20.h,
                  MonthsTabs(
                    selectedMonth: selectedMonth,
                    onMonthSelected: (month) {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                  ),
                  20.h,
                  hasData
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Доход', style: AppTextStyles.f16w500),
                          20.h,
                          MonthlyReportChart(),
                          20.h,
                          _dynamicLegendSection(dynamicLegendData),
                          40.h,
                          _dataTableSection(data),
                        ],
                      )
                      : const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Text('Нет данных за выбранный месяц'),
                        ),
                      ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  List<Map<String, String>> _calculateMonthlyData(
    List<AllTransactionsModel> transactions,
    String month,
  ) {
    Decimal income = Decimal.zero;
    Decimal expense = Decimal.zero;

    for (var tx in transactions) {
      if (tx.date != null &&
          DateTime.parse(tx.date!).month.toString() == month) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
        if (tx.transactionType == 'income') {
          income += amount;
        } else if (tx.transactionType == 'expense') {
          expense += amount;
        }
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

  Widget _dynamicLegendSection(List<Map<String, String>> dynamicLegendData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          dynamicLegendData
              .map<Widget>(
                (item) =>
                    _legendItem(color: item['color']!, text: item['name']!),
              )
              .toList(),
    );
  }

  Widget _legendItem({required String color, required String text}) {
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

  List<Map<String, String>> _getLegendDataFromAPI(
    List<IncomeExpenseReasons> reasons,
  ) {
    final List<Map<String, String>> legendData = [];
    final List<String> colors = [
      '0xFF7B37B5',
      '0xFFF219A2',
      '0xFF156CB1',
      '0xFFCCC9AA',
      '0xFF1EBF93',
      '0xFFFCA12C',
    ];

    for (var i = 0; i < reasons.length; i++) {
      legendData.add({
        'name': reasons[i].name,
        'color': colors[i % colors.length],
      });
    }

    return legendData;
  }

  Widget _dataTableSection(List<Map<String, String>> data) {
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
            data
                .map(
                  (row) => DataRow(
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
                  ),
                )
                .toList(),
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
    Color(0xFF7B37B5), // фиолетовый
    Color(0xFFF219A2), // розовый
    Color(0xFF156CB1), // синий
    Color(0xFFCCC9AA), // бежевый
    Color(0xFF1EBF93), // зеленый
    Color(0xFFFCA12C), // оранжевый
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

class MonthsTab extends StatelessWidget {
  const MonthsTab({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  final String selectedMonth;
  final Function(String) onMonthSelected;

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
