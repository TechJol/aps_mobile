// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MetricsPage extends StatelessWidget {
  const MetricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Показатели',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            20.h,
            Row(
              children: [
                OutlinedButtonWidget(text: 'Транзакции', onPressed: () {}),
                12.w,
                OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
              ],
            ),
            20.h,
            DropDownFormField(
              items: ['по годам'],
              label: 'Выберите период',
              value: '',
              onChanged: (value) {},
            ),
            40.h,
            Text(
              'Таблица доходов и расходов по годам',
              style: AppTextStyles.f16w500,
            ),
            20.h,
            _buildMetrics(),
            60.h,
            Text(
              'График доходов и расходов по годам',
              style: AppTextStyles.f16w500,
            ),
            30.h,
            _buildGraphic(),
          ],
        ),
      ),
    );
  }

  _buildMetrics() {
    final int rowsPerPage = 2;
    int currentPage = 1;
    final List<Map<String, String>> data = List.generate(223, (index) {
      return {
        'Год': '${index + 2024}',
        'Доход (KGZ)': 'Доход от продажи',
        'Расход (KGZ)': '444544',
        'Чистый доход (KGZ)': '34%',
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
          DataColumn(label: Text('Год')),
          DataColumn(label: Text('Доход (KGZ)')),
          DataColumn(label: Text('Расход (KGZ)')),
          DataColumn(label: Text('Чистый доход (KGZ)')),
        ],
        rows:
            paginatedData.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['Год']!)),
                  DataCell(
                    Text(
                      row['Доход (KGZ)']!,
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['Расход (KGZ)']!,
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['Чистый доход (KGZ)']!,
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildGraphic() {
    final years = ['2024', '2025', '2026', '2027'];

    final List<List<double>> data = [
      [23000.0, 21000.0, 0, 0, 0, 0],
      [0, 0, 40000.0, 25000.0, 5000.0, 0],
      [0, 1000, 4000.0, 30000.0, 5000.0, 0],
      [2000, 3000, 5000, 6000, 7000, 8000],
    ];

    final colors = [
      Color(0xFF7B37B5),
      Color(0xFFF219A2),
      Color(0xFF156CB1),
      Color(0xFFCCC9AA),
      Color(0xFF1EBF93),
      Color(0xFFFCA12C),
    ];

    const double barWidth = 170;
    const double groupSpacing = 20;

    double calculateChartWidth(int itemCount) {
      if (itemCount == 0) return 0;
      return itemCount * barWidth + (itemCount - 1) * groupSpacing + 40;
    }

    final chartWidth = calculateChartWidth(years.length);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: 400,
        child: BarChart(
          BarChartData(
            maxY: 90000,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20000,
              getDrawingHorizontalLine:
                  (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20000,
                  getTitlesWidget: (value, _) {
                    return Text(value.toInt().toString());
                  },
                  reservedSize: 70,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < years.length) {
                      return Text(years[index]);
                    }
                    return const SizedBox.shrink();
                  },
                  reservedSize: 20,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false, reservedSize: 30),
              ),
            ),
            barGroups: List.generate(years.length, (index) {
              final vals = data[index];
              double sum = 0;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: vals.reduce((a, b) => a + b).toDouble(),
                    rodStackItems: List.generate(vals.length, (i) {
                      final start = sum;
                      sum += vals[i];
                      return BarChartRodStackItem(start, sum, colors[i]);
                    }),
                    width: barWidth,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }),
            groupsSpace: groupSpacing,
          ),
        ),
      ),
    );
  }
}
