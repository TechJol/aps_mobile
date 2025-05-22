import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class DropdownFormField extends StatelessWidget {
  const DropdownFormField({
    super.key,
    required this.currencies,
    this.value,
    this.onChanged,
    required this.label,
  });

  final List<String> currencies;
  final String? value;
  final void Function(String?)? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const SizedBox.shrink(),
      value: value,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 30,
          color: AppColors.greyerColor,
        ),
        labelText: label,
        fillColor: AppColors.backroundColor,
        filled: true,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items:
          currencies
              .map(
                (currency) =>
                    DropdownMenuItem(value: currency, child: Text(currency)),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}
