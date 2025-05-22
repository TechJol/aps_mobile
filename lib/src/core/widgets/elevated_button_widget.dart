import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({super.key, this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColorLight,
              foregroundColor: Colors.white,
              fixedSize: const Size(double.infinity, 48),
            ),
            child: Text(text, style: AppTextStyles.f16w500),
          ),
        ),
      ],
    );
  }
}
