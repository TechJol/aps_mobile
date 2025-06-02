import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class TextFieldWid extends StatelessWidget {
  const TextFieldWid({super.key, this.controller, required this.label});

  final TextEditingController? controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        labelStyle: AppTextStyles.f16w500,
        fillColor: AppColors.backroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.backroundColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.backroundColor,
          ),
        ),
        hintText: label,
        // labelText: label,
      ),
    );
  }
}
