import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class HeaderBalanceContainer extends StatelessWidget {
  const HeaderBalanceContainer({
    super.key,
    required this.title,
    required this.amount,
    required this.bgColor,
  });

  final String title;
  final String amount;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.f14w500.copyWith(color: Colors.white),
            ),
            8.h,
            Text(
              amount,
              style: AppTextStyles.f12w600.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
