import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class MonthsTabs extends StatelessWidget {
  const MonthsTabs({
    super.key,
    required this.onMonthSelected,
    required this.selectedMonth,
    required this.months,
    this.scrollController,
  });

  final Function(String) onMonthSelected;
  final String selectedMonth;
  final List<String> months;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Row(
        children: months.asMap().entries.map((entry) {
          String monthNumber = (entry.key + 1).toString();
          bool isSelected = monthNumber == selectedMonth;

          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => onMonthSelected(monthNumber),
              child: Text(
                entry.value,
                style: AppTextStyles.f12w400.copyWith(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.greyColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
