import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class LegendSection extends StatelessWidget {
  const LegendSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.asMap().entries.map((entry) {
        final color = _chartColors[entry.key % _chartColors.length];
        return LegendItem(color: color, text: entry.value['name']);
      }).toList(),
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
