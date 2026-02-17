import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class PeriodOption extends StatelessWidget {
  final String label;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const PeriodOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = label == selected;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: scheme.outlineVariant, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.f16w500.copyWith(color: scheme.onSurface),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: scheme.onSurfaceVariant,
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: scheme.outlineVariant, width: 1),
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    return isSelected ? AppColors.primaryColor : scheme.surface;
                  }),
                  checkColor: WidgetStateProperty.all(Colors.white),
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
