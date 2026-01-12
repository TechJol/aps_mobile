import 'package:finik_sdk/finik_sdk.dart';
import 'package:flutter/material.dart';

class FinikPaymentPage extends StatelessWidget {
  const FinikPaymentPage({
    super.key,
    required this.apiKey,
    required this.accountId,
    required this.amount,
    required this.itemNameEn,
    required this.description,
    required this.callbackUrl,
    required this.locale,
  });

  final String apiKey;
  final String accountId;
  final double amount;
  final String itemNameEn;
  final String description;
  final String? callbackUrl;
  final FinikSdkLocale locale;

  @override
  Widget build(BuildContext context) {
    return FinikProvider(
      apiKey: apiKey,
      isBeta: false,
      locale: locale,
      textScenario: TextScenario.PAYMENT,
      paymentMethods: const [PaymentMethod.APP, PaymentMethod.QR],
      enableShimmer: true,
      enableShare: true,
      enableSupportButtons: true,
      tapableSupportButtons: true,
      onBackPressed: () => Navigator.of(context).maybePop(),
      onPayment: (data) {
        final status = (data!['status'] ?? '').toString().toUpperCase();
        Navigator.of(context).pop(status == 'SUCCEEDED');
      },
      widget: CreateItemHandlerWidget(
        accountId: accountId,
        nameEn: itemNameEn,
        amount: FixedAmount(amount),
        description: description,
        callbackUrl: callbackUrl,
      ),
    );
  }
}
