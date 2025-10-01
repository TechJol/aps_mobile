import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/enums/home_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OperationFilters extends StatelessWidget {
  final ViewType selectedView;
  final ValueChanged<ViewType> onChanged;

  const OperationFilters({
    super.key,
    required this.selectedView,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = ViewType.values;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((view) {
            final isSelected = selectedView == view;

            String icon;
            switch (view) {
              case ViewType.all:
                icon = 'assets/images/vector_all.svg';
                break;
              case ViewType.income:
                icon = 'assets/images/vector_down.svg';
                break;
              case ViewType.expense:
                icon = 'assets/images/vector_up.svg';
                break;
            }

            String label;
            switch (view) {
              case ViewType.expense:
                label = t.home.expenses;
                break;
              case ViewType.income:
                label = t.home.income;
                break;
              case ViewType.all:
                label = t.home.all;
                break;
            }

            return Column(
              children: [
                GestureDetector(
                  onTap: () => onChanged(view),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: SvgPicture.asset(
                      icon,
                      fit: BoxFit.scaleDown,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        isSelected ? Colors.white : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
