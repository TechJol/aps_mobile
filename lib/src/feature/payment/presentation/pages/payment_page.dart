// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      body: SafeArea(
        child: const PaymentContent(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        ),
      ),
    );
  }
}

class PaymentAlertDialog extends StatelessWidget {
  const PaymentAlertDialog({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420),
              child: PaymentContent(padding: EdgeInsets.zero, isCompact: true),
            ),
          ),
          Positioned(
            right: 6,
            top: 0,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                color: AppColors.greyerColorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanOption {
  const PlanOption({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.highlight,
    this.badge,
  });

  final String title;
  final String price;
  final String subtitle;
  final bool highlight;
  final String? badge;
}
