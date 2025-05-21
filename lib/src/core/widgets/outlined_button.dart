import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({super.key, this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(fixedSize: Size(double.infinity, 48)),
        child: Text(
          text,
          style: AppTextStyles.f14w500.copyWith(color: AppColors.blackColor),
        ),
      ),
    );
  }
}
