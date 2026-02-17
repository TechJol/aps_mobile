import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: scheme.surfaceContainerHighest,
            border: Border.all(color: scheme.outlineVariant, width: 1),
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
}
