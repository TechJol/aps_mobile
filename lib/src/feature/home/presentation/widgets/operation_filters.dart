import 'package:aps_mobile/src/core/core.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((view) {
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
                  color: isSelected
                      ? (isDark
                            ? AppColors.primaryColorLight.withValues(alpha: 0.35)
                            : scheme.onSurface)
                      : (isDark ? scheme.surfaceContainerHighest : scheme.surface),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit.scaleDown,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? (isDark ? Colors.white : scheme.surface)
                        : scheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            30.h,
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: scheme.onSurface,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
