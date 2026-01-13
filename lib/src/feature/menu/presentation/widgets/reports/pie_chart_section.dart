import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: w * 0.8,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: w * 0.16,
          sections: data.asMap().entries.map((entry) {
            final color = _chartColors[entry.key % _chartColors.length];
            final percent = (entry.value['percent'] as Decimal).toDouble();

            return PieChartSectionData(
              color: color,
              value: percent,
              title: '${percent.round()}%',
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              titlePositionPercentageOffset: 0.6,
              radius: w * 0.2,
            );
          }).toList(),
        ),
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
