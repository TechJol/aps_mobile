// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:aps_mobile/settings.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  _PieChartPageState createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  int selectedIndex = 0;
  String selectedView = 'Spending';
  String selectedPeriod = 'Аналитика';

  final viewOptions = ['Расходы', 'Доход', 'Общий'];
  final periodOptions = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  void updateState<T>(T value, void Function(T) updater) =>
      setState(() => updater(value));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Привет,  Aяна',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 30),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Settings()),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            _buildTopSection(),
            const SizedBox(height: 15),
            _buildOperationFilters(),
            const SizedBox(height: 20),
            _buildOperationsHeader(),
            const SizedBox(height: 8),
            const Text(
              'Today --------------------------------------',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$selectedView view content goes here',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(
      //   selectedIndex: selectedIndex,
      //   onItemTapped: (i) => updateState(i, (val) => selectedIndex = val),
      // ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      height: 215,
      width: 335,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleIcon(Icons.arrow_back_ios_rounded, Offset(-25, 70)),
              Transform.translate(
                offset: const Offset(-110, -13),
                child: Text(
                  selectedPeriod,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _circleIcon(Icons.arrow_forward_ios_rounded, Offset(25, 70)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.translate(
                offset: const Offset(12, 3),
                child: CustomPaint(
                  size: const Size(106, 106),
                  painter: PieChartPainter(),
                ),
              ),
              _legend(),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: periodOptions.map((p) => _periodButton(p)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, Offset offset) => Transform.translate(
    offset: offset,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      padding: const EdgeInsets.all(5),
      child: Icon(icon, size: 20),
    ),
  );

  Widget _legend() {
    const items = [
      {'color': Colors.purpleAccent, 'label': 'Аренда'},
      {'color': Colors.blueAccent, 'label': 'Зарплата'},
      {'color': Colors.purple, 'label': 'Прочие расходы'},
    ];
    return Padding(
      padding: const EdgeInsets.only(right: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: item['color'] as Color,
                          radius: 5,
                        ),
                        const SizedBox(width: 6),
                        Text(item['label'] as String),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _periodButton(String period) => GestureDetector(
    onTap: () => updateState(period, (val) => selectedPeriod = val),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        period,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          fontSize: 13,
          color: selectedPeriod == period ? Colors.black : Colors.grey,
        ),
      ),
    ),
  );

  Widget _buildOperationFilters() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children:
        viewOptions.map((view) {
          final isSelected = selectedView == view;
          final icon =
              view == 'Общий' ? Icons.stacked_bar_chart : Icons.arrow_back;
          return Column(
            children: [
              SizedBox(
                width: 103,
                height: 43,
                child: ElevatedButton(
                  onPressed:
                      () => updateState(view, (val) => selectedView = val),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.black : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Icon(icon, size: 20),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                view,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),
            ],
          );
        }).toList(),
  );

  Widget _buildOperationsHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text(
        'Operations',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          Text(
            'view all',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    ],
  );
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const segments = [
      {'color': Colors.purpleAccent, 'sweep': 2.0},
      {'color': Colors.blueAccent, 'sweep': 2.1},
      {'color': Colors.deepPurpleAccent, 'sweep': 2.18},
    ];
    const gap = 0.27;
    double start = 0;

    for (var seg in segments) {
      paint.color = seg['color'] as Color;
      final sweep = (seg['sweep'] as double) - gap;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += seg['sweep'] as double;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
