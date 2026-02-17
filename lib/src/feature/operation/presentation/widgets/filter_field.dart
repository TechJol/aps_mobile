import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class OperationFilterField extends StatelessWidget {
  const OperationFilterField({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: TextFormField(
          onTap: onTap,
          readOnly: true,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            labelStyle: AppTextStyles.f16w500.copyWith(color: scheme.onSurface),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: scheme.onSurfaceVariant,
            ),
            fillColor: scheme.surfaceContainerHighest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: scheme.surfaceContainerHighest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: scheme.surfaceContainerHighest),
            ),
            hintText: label.isEmpty ? t.operation.selectPeriod : label,
          ),
        ),
      ),
    );
  }
}
