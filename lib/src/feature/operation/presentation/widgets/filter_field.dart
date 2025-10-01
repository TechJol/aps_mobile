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
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F7),
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
            labelStyle: AppTextStyles.f16w500,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
            fillColor: AppColors.backroundColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: AppColors.backroundColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: AppColors.backroundColor),
            ),
            hintText: label.isEmpty ? t.operation.selectPeriod : label,
          ),
        ),
      ),
    );
  }
}
