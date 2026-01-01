import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      const _PlanOption(
        title: '1 месяц',
        price: '299 сом',
        subtitle: 'Пробный тариф',
        highlight: false,
      ),
      const _PlanOption(
        title: '3 месяца',
        price: '699 сом',
        subtitle: 'Экономия 20%',
        highlight: true,
        badge: 'Рекомендуем',
      ),
      const _PlanOption(
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

    return Scaffold(
      backgroundColor: AppColors.backroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            const _HeaderCard(),
            const SizedBox(height: 24),
            Text(
              'Оформите подписку',
              style: AppTextStyles.f24w600.copyWith(
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Откройте все возможности APS и управляйте финансами без'
              ' ограничений.',
              style: AppTextStyles.f14w400.copyWith(
                color: AppColors.smallTextGreyColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            for (final feature in features) ...[
              _FeatureRow(text: feature),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),
            Text(
              'Выберите тариф',
              style: AppTextStyles.f18w600.copyWith(
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 12),
            for (final plan in plans) ...[
              _PlanCard(option: plan),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 16),
            const ElevatedButtonWidget(text: 'Оформить подписку'),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: Text(
                'Подробнее о подписке',
                style: AppTextStyles.f14w500.copyWith(
                  color: AppColors.greyerColorLight,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Подписка продлевается автоматически. Отменить можно в любой'
              ' момент в настройках.',
              textAlign: TextAlign.center,
              style: AppTextStyles.f12w400.copyWith(
                color: AppColors.smallTextGreyColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primaryColorLight, AppColors.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APS Premium',
                  style: AppTextStyles.f20w700.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Полный доступ к сервису\nдля вашего бизнеса',
                  style: AppTextStyles.f14w400.copyWith(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/cardimage.png',
              width: 88,
              height: 88,
              fit: BoxFit.cover,
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
          size: 20,
          color: AppColors.greenColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.f14w500.copyWith(
              color: AppColors.blackColorLight,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.option});

  final _PlanOption option;

  @override
  Widget build(BuildContext context) {
    final borderColor = option.highlight
        ? AppColors.primaryColorLight
        : AppColors.greyColorLight;
    final backgroundColor = option.highlight
        ? AppColors.nextbackColor
        : AppColors.whiteColor;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: AppTextStyles.f18w600.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.subtitle,
                      style: AppTextStyles.f12w400.copyWith(
                        color: AppColors.smallTextGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    option.price,
                    style: AppTextStyles.f18w600.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'за период',
                    style: AppTextStyles.f12w400.copyWith(
                      color: AppColors.smallTextGreyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (option.badge != null)
          Positioned(
            right: 12,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColorLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                option.badge!,
                style: AppTextStyles.f12w600.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PlanOption {
  const _PlanOption({
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
