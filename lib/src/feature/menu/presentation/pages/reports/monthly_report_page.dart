import 'package:aps_mobile/src/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Meсячный отчет',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            20.h,
            Row(
              children: [
                OutlinedButtonWidget(text: 'Распечатать', onPressed: () {}),
                SizedBox(width: 12),
                OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
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
                  20.h,
                  MonthlyReportChart(),
                  20.h,
                  _legendSection(),
                ],
              ),
            ),
            40.h,
            _dataTableSection(),
          ],
        ),
      ),
    );
  }

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

  _legendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legendItem(color: Color(0xFF7B37B5), text: 'Открытие ИП'),
        _legendItem(color: Color(0xFFF219A2), text: 'Открытие ОсОО'),
        _legendItem(color: Color(0xFF156CB1), text: 'Доход от продажи'),
        _legendItem(color: Color(0xFFCCC9AA), text: 'Гражданское дело'),
        _legendItem(color: Color(0xFF1EBF93), text: 'Инвестиции'),
        _legendItem(color: Color(0xFFFCA12C), text: 'Выручка'),
      ],
    );
  }

  _legendItem({required Color color, required String text}) {
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

  _dataTableSection() {
    final int rowsPerPage = 10;
    int currentPage = 1;

    final List<Map<String, String>> data = List.generate(223, (index) {
      return {
        'Месяц': '2024-10',
        'Доход (KGZ)': '120037,00',
        'Расход (KGZ)': '9999',
        'Чистый доход (KGZ)': '156666',
      };
    });

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
                  DataCell(Text(row['Месяц']!)),
                  DataCell(
                    Text(
                      row['Доход (KGZ)']!,
                      style: TextStyle(color: AppColors.greenColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['Расход (KGZ)']!,
                      style: TextStyle(color: AppColors.redColor),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['Чистый доход (KGZ)']!,
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
