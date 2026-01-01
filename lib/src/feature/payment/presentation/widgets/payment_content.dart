import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:aps_mobile/src/feature/payment/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PaymentContent extends StatelessWidget {
  const PaymentContent({
    super.key,
    required this.padding,
    this.isCompact = false,
  });

  final EdgeInsets padding;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final plans = [
      const PlanOption(
        title: '1 месяц',
        price: '299 сом',
        subtitle: 'Пробный тариф',
        highlight: false,
      ),
      const PlanOption(
        title: '3 месяца',
        price: '699 сом',
        subtitle: 'Экономия 20%',
        highlight: true,
        badge: 'Рекомендуем',
      ),
      const PlanOption(
        title: '12 месяцев',
        price: '1999 сом',
        subtitle: 'Экономия 45%',
        highlight: false,
      ),
    ];
    final features = [
      'Безлимитные операции и отчеты',
      'История, аналитика и экспорт',
      'Поддержка 24/7 в приложении',
    ];

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderCard(),
          SizedBox(height: isCompact ? 18 : 24),
          Text(
            'Оформите подписку',
            style: AppTextStyles.f20w600.copyWith(color: AppColors.blackColor),
          ),
          8.h,
          Text(
            'Откройте все возможности SoftkgPro и управляйте финансами без'
            ' ограничений.',
            style: AppTextStyles.f12w400.copyWith(
              color: AppColors.smallTextGreyColor,
              height: 1.4,
            ),
          ),
          12.h,
          for (final feature in features) ...[_FeatureRow(text: feature), 8.h],
          8.h,
          Text(
            'Выберите тариф',
            style: AppTextStyles.f14w600.copyWith(color: AppColors.blackColor),
          ),
          10.h,
          for (final plan in plans) ...[PlanCard(option: plan), 12.h],
          12.h,
          const ElevatedButtonWidget(text: 'Оформить подписку'),
          10.h,
          Text(
            'Подписка продлевается автоматически. Отменить можно в любой'
            ' момент в настройках.',
            textAlign: TextAlign.center,
            style: AppTextStyles.f9w400.copyWith(
              color: AppColors.smallTextGreyColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: AppColors.greenColor,
        ),
        8.w,
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.f10w500.copyWith(
              color: AppColors.blackColorLight,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
