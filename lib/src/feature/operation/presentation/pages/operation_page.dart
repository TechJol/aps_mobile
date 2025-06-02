import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class OperationPage extends StatelessWidget {
  const OperationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      {
        'title': 'ОсОО Кашгар',
        'datetime': '29.05.2025 - 13:13',
        'amount': -1200,
        'isIncome': false,
      },
      // Добавь остальные операции сюда
    ];

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
      body: ListView(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFF3F4F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFieldWid(label: 'Выбрать период'),
            ),
          ),
          30.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Операции', style: AppTextStyles.f20w600),
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
}
