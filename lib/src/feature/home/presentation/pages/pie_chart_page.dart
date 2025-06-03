// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> operations = const [
    {
      'title': 'ОсОО Кашгар',
      'datetime': '29.05.2025 - 13:13',
      'amount': -1200,
      'isIncome': false,
    },
    {
      'title': 'ОсОО Кашгар',
      'datetime': '29.05.2025 - 13:13',
      'amount': 1200,
      'isIncome': true,
    },
    {
      'title': 'ОсОО Кашгар',
      'datetime': '29.05.2025 - 13:13',
      'amount': 1200,
      'isIncome': true,
    },

    // Добавь остальные операции сюда
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F4F7),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: const Text('Привет , Aяна', style: AppTextStyles.f24w600),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.menu);
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                _buildTopSection(),
                const SizedBox(height: 15),
                _buildOperationFilters(),
              ],
            ),
          ),
          30.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Операции', style: AppTextStyles.f20w600),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'смотреть все',
                          style: AppTextStyles.f14w500.copyWith(
                            color: AppColors.smallTextGreyColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.smallTextGreyColor,
                        ),
                      ],
                    ),
                  ],
                ),
                12.h,
                Row(
                  children: [
                    Text(
                      'Сегодня',
                      style: AppTextStyles.f14w500.copyWith(
                        color: AppColors.smallTextGreyColor,
                      ),
                    ),
                    8.w,
                    Expanded(
                      child: Divider(
                        thickness: 0.3,
                        color: AppColors.smallTextGreyColor,
                      ),
                    ),
                  ],
                ),
                12.h,
                ...operations.map((op) => _buildOperationItem(op)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationItem(Map<String, dynamic> operation) {
    final bool isIncome = operation['isIncome'] ?? false;
    final Color bgColor =
        isIncome ? const Color(0xFFDFF7E2) : const Color(0xFFF9DCDC);
    final Color arrowColor =
        isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445);
    final IconData arrowIcon =
        isIncome ? Icons.call_received : Icons.north_west;
    final int amount = operation['amount'] ?? 0;
    final String amountText = '${amount.abs()} с';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(arrowIcon, color: arrowColor, size: 20),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(operation['title'] ?? '', style: AppTextStyles.f14w500),
                4.h,
                Text(
                  operation['datetime'] ?? '',
                  style: AppTextStyles.f12w400.copyWith(
                    color: AppColors.smallTextGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '' : '-'}$amountText',
            style: AppTextStyles.f16w600.copyWith(
              color:
                  isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      height: 215,
      width: double.infinity,
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
              _circleIcon(Icons.arrow_back_ios_rounded, Offset(-22, 70)),
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
              _circleIcon(Icons.arrow_forward_ios_rounded, Offset(22, 70)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.translate(
                offset: const Offset(15, 3),
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
              view == 'Общий' ? Icons.stacked_bar_chart : Icons.call_received;
          return Column(
            children: [
              GestureDetector(
                onTap: () => updateState(view, (val) => selectedView = val),
                child: Container(
                  width: 103,
                  height: 43,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                view,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
              ),
            ],
          );
        }).toList(),
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
