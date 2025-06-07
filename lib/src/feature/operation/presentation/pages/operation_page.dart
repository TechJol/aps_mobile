import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          child: const Text('Привет, Aяна', style: AppTextStyles.f24w600),
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
              // child: TextFieldWid(label: 'Выбрать период'),
              child: TextFormField(
                onTap: () {
                  _showPeriodPickerBottomSheet(context);
                },
                readOnly: true,
                // controller: controller,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  labelStyle: AppTextStyles.f16w500,
                  suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
                  fillColor: AppColors.backroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: AppColors.backroundColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 1,
                      color: AppColors.backroundColor,
                    ),
                  ),
                  hintText: 'Выбрать период',
                  // labelText: label,
                ),
              ),
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

  void _showPeriodPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
        DateTime endDate = DateTime.now();
        String selectedPeriod = 'Неделя';

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _dateField(
                          label: 'Начало',
                          date: startDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        _dateField(
                          label: 'Конец',
                          date: endDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _periodOption(
                      'Неделя',
                      selectedPeriod,
                      (val) => setState(() => selectedPeriod = val!),
                    ),
                    _periodOption(
                      'За месяц',
                      selectedPeriod,
                      (val) => setState(() => selectedPeriod = val!),
                    ),
                    _periodOption(
                      'Три месяца',
                      selectedPeriod,
                      (val) => setState(() => selectedPeriod = val!),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColorLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Показать'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.backroundColor,
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.f12w400),
                  2.h,
                  Text(
                    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                    style: AppTextStyles.f14w500,
                  ),
                ],
              ),
              SvgPicture.asset('assets/icons/calendar.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _periodOption(
    String label,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    final bool isSelected = label == selected;

    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.backroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.f16w500.copyWith(color: Colors.black),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.grey.shade400,
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // 👈 вместо CircleBorder
                  ),

                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    return isSelected ? AppColors.primaryColor : Colors.white;
                  }),
                  checkColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onChanged(label),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
