import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class TextFieldWid extends StatelessWidget {
  const TextFieldWid({
    super.key,
    this.controller,
    required this.label,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String label;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        labelStyle: AppTextStyles.f16w500.copyWith(color: scheme.onSurfaceVariant),
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: scheme.surfaceContainerHighest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(width: 1, color: scheme.surfaceContainerHighest),
        ),
        hintText: label,
        // labelText: label,
      ),
    );
  }
}
