import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            final subscription = state.activeSubscription;
            final plan = subscription == null
                ? null
                : state.plans.firstWhere(
                    (plan) => plan.id == subscription.plan,
                    orElse: () => PlanEntity(
                      id: subscription.plan ?? 0,
                      name: 'Пакет',
                      pricePerMonth: 0,
                      isActive: false,
                    ),
                  );
            final period = subscription == null
                ? null
                : state.periods.firstWhere(
                    (period) => period.id == subscription.period,
                    orElse: () => PeriodEntity(
                      id: subscription.period ?? 0,
                      name: '',
                      months: 0,
                      discountPercent: 0,
                    ),
                  );

            final endDate = _formatDate(subscription?.endDate);
            final total = _calculateTotal(plan, period);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ваш платеж успешно завершен!',
                  style: AppTextStyles.f16w600.copyWith(
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                12.h,
                Text(
                  'Поздравляем! Теперь вы являетесь участником плана'
                  ' ${plan?.name ?? '-'}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.f12w400.copyWith(
                    color: AppColors.smallTextGreyColor,
                  ),
                ),
                12.h,
                _InfoRow(
                  label: 'Период подписки',
                  value: period == null
                      ? '-'
                      : '${period.name} (${period.months} мес.)',
                ),
                _InfoRow(label: 'Дата окончания', value: endDate ?? '-'),
                _InfoRow(
                  label: 'Сумма платежа',
                  value: total == null
                      ? '-'
                      : '${total.toStringAsFixed(0)} сом',
                ),
                16.h,
                ElevatedButtonWidget(
                  text: 'Главное',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    return '${parsed.day.toString().padLeft(2, '0')}.'
        '${parsed.month.toString().padLeft(2, '0')}.${parsed.year}';
  }

  double? _calculateTotal(PlanEntity? plan, PeriodEntity? period) {
    if (plan == null || period == null) return null;
    final base = plan.pricePerMonth * period.months;
    final discount = period.discountPercent / 100;
    return base * (1 - discount);
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.f12w400.copyWith(
              color: AppColors.smallTextGreyColor,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.f12w600.copyWith(
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
