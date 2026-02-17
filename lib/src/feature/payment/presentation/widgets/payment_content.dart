// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:aps_mobile/src/core/core.dart';
// import 'package:aps_mobile/injection_container.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/payment/presentation/widgets/widgets.dart';
import 'package:finik_sdk/finik_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentContent extends StatefulWidget {
  const PaymentContent({
    super.key,
    required this.padding,
    this.isCompact = true,
    this.onPaymentSuccess,
  });

  final EdgeInsets padding;
  final bool isCompact;
  final VoidCallback? onPaymentSuccess;

  @override
  State<PaymentContent> createState() => _PaymentContentState();
}

class _PaymentContentState extends State<PaymentContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentCubit>().load();
      context.read<PaymentCubit>().fetchSubscriptions();
      context.read<MenuCubit>().getTransactionsWithAccounts(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocListener<PaymentCubit, PaymentState>(
      listenWhen: (previous, current) =>
          previous.paymentUrl != current.paymentUrl &&
          current.paymentUrl != null,
      listener: (context, state) async {
        final url = state.paymentUrl;
        if (url == null) return;
        context.read<PaymentCubit>().clearPaymentUrl();

        final rootNavigator = Navigator.of(context, rootNavigator: true);
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PaymentWebViewPage(paymentUrl: url),
          ),
        );

        if (!mounted) return;
        if (result == true) {
          await context.read<PaymentCubit>().fetchSubscriptions();
          if (!mounted) return;
          final activeSubscription = context
              .read<PaymentCubit>()
              .state
              .activeSubscription;
          if (activeSubscription == null) {
            ScaffoldMessenger.of(rootNavigator.context).showSnackBar(
              SnackBar(
                content: Text(t.payment.paymentProcessedSnack),
                action: SnackBarAction(
                  label: t.payment.refreshStatus,
                  onPressed: () =>
                      context.read<PaymentCubit>().fetchSubscriptions(),
                ),
              ),
            );
            return;
          }
          widget.onPaymentSuccess?.call();
          if (!mounted) return;
          showDialog<void>(
            context: rootNavigator.context,
            barrierDismissible: false,
            builder: (_) => const PaymentSuccessDialog(),
          );
        }
      },
      child: BlocBuilder<PaymentCubit, PaymentState>(
        builder: (context, state) {
          if (state.isLoading && state.plans.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null &&
              state.plans.isEmpty &&
              state.periods.isEmpty) {
            return _ErrorState(message: state.error!);
          }

          final features = [
            t.payment.features.unlimitedOps,
            t.payment.features.historyAnalytics,
            t.payment.features.support,
          ];
          final options = _buildPlanOptions(state);
          final activeInfo = _buildActiveInfo(state);

          return SingleChildScrollView(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderCard(),
                SizedBox(height: widget.isCompact ? 18 : 24),
                Text(
                  t.payment.subscribeTitle,
                  style: AppTextStyles.f20w600.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                8.h,
                Text(
                  t.payment.subscribeDescription,
                  style: AppTextStyles.f12w400.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                12.h,
                if (activeInfo != null) ...[activeInfo, 12.h],
                for (final feature in features) ...[
                  _FeatureRow(text: feature),
                  8.h,
                ],
                8.h,
                Text(
                  t.payment.choosePlanTitle,
                  style: AppTextStyles.f14w600.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                10.h,
                if (options.isEmpty)
                  Text(
                    t.payment.plansUnavailable,
                    style: AppTextStyles.f12w400.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                else
                  for (final option in options) ...[
                    PlanCard(
                      option: option,
                      onTap: () => context.read<PaymentCubit>().selectPeriod(
                        option.periodId,
                      ),
                    ),
                    12.h,
                  ],
                12.h,
                ElevatedButtonWidget(
                  text: t.payment.subscribeButton,
                  onPressed: state.isStarting
                      ? null
                      : () => _openFinikPayment(context, state),
                ),
                10.h,
                Text(
                  t.payment.autoRenew,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.f9w400.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openFinikPayment(
    BuildContext context,
    PaymentState state,
  ) async {
    final plan = _selectPlan(state);
    final period = state.periods.firstWhere(
      (item) => item.id == state.selectedPeriodId,
      orElse: () =>
          PeriodEntity(id: 0, name: '', months: 0, discountPercent: 0),
    );
    if (plan == null || period.id == 0) return;

    const accountId = 'ee0290fe-8eaf-4570-9e86-ed13aac71678';

    final amount = _calculatePrice(plan.pricePerMonth, period);
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FinikPaymentPage(
          apiKey: 'ncupjG10C15pAzBhO8CbV6wtgiIQKz487NqI3UW0',
          accountId: accountId,
          amount: amount,
          itemNameEn: plan.name.isEmpty ? 'SoftkgPro' : plan.name,
          description: plan.name.isEmpty ? 'SoftkgPro subscription' : plan.name,
          callbackUrl: _finikCallbackUrl,
          locale: _resolveFinikLocale(),
        ),
      ),
    );

    if (!context.mounted) return;
    if (result == true) {
      await context.read<PaymentCubit>().fetchSubscriptions();
      if (!context.mounted) return;
      final rootNavigator = Navigator.of(context, rootNavigator: true);
      showDialog<void>(
        context: rootNavigator.context,
        barrierDismissible: false,
        builder: (_) => const PaymentSuccessDialog(),
      );
    }
  }

  FinikSdkLocale _resolveFinikLocale() {
    switch (LocaleSettings.currentLocale) {
      case AppLocale.ky:
        return FinikSdkLocale.KY;
      case AppLocale.ru:
        return FinikSdkLocale.RU;
      case AppLocale.en:
        return FinikSdkLocale.EN;
    }
  }

  static const String? _finikCallbackUrl = null;

  Widget? _buildActiveInfo(PaymentState state) {
    final active = state.activeSubscription;
    if (active == null) return null;

    final planName = state.plans
        .firstWhere(
          (plan) => plan.id == active.plan,
          orElse: () => PlanEntity(
            id: active.plan ?? 0,
            name: t.payment.planFallback,
            pricePerMonth: 0,
            isActive: false,
          ),
        )
        .name;

    final daysLeft = _daysLeft(active.endDate);
    if (daysLeft == null) return null;

    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.greenColor.withValues(alpha: 0.18)
                : AppColors.greenColorLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.greenColor),
              8.w,
              Expanded(
                child: Text(
                  t.payment.activeStatus
                      .replaceAll('{planName}', planName)
                      .replaceAll('{daysLeft}', daysLeft.toString()),
                  style: AppTextStyles.f12w500.copyWith(
                    color: isDark ? AppColors.greenColor50 : AppColors.greenColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int? _daysLeft(String endDate) {
    if (endDate.isEmpty) return null;
    final parsed = DateTime.tryParse(endDate);
    if (parsed == null) return null;
    final diff = parsed.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  List<PlanOption> _buildPlanOptions(PaymentState state) {
    if (state.plans.isEmpty || state.periods.isEmpty) return [];
    final plan = _selectPlan(state);
    if (plan == null) return [];

    final maxDiscount = state.periods.isEmpty
        ? 0
        : state.periods.map((period) => period.discountPercent).reduce(max);

    return state.periods.map((period) {
      final price = _calculatePrice(plan.pricePerMonth, period);
      final isSelected = period.id == state.selectedPeriodId;
      final highlight =
          period.discountPercent == maxDiscount && maxDiscount > 0;
      final subtitle = period.discountPercent > 0
          ? t.payment.discountSubtitle.replaceAll(
              '{percent}',
              period.discountPercent.toString(),
            )
          : t.payment.trialSubtitle;

      return PlanOption(
        periodId: period.id,
        title: '${period.months} ${_monthLabel(period.months)}',
        price: '${price.toStringAsFixed(0)} ${t.payment.currencyKgs}',
        subtitle: subtitle,
        highlight: highlight,
        badge: highlight ? t.payment.recommendedBadge : null,
        isSelected: isSelected,
      );
    }).toList();
  }

  PlanEntity? _selectPlan(PaymentState state) {
    if (state.plans.isEmpty) return null;
    final active = state.plans.where((plan) => plan.isActive).toList();
    return active.isNotEmpty ? active.first : state.plans.first;
  }

  double _calculatePrice(double pricePerMonth, PeriodEntity period) {
    final base = pricePerMonth * period.months;
    final discount = period.discountPercent / 100;
    return base * (1 - discount);
  }

  String _monthLabel(int months) {
    return t.payment.months(n: months);
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
            style: AppTextStyles.f12w500.copyWith(
              color: scheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.f12w400.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            12.h,
            TextButton(
              onPressed: () => context.read<PaymentCubit>().load(),
              child: Text(
                t.payment.retryButton,
                style: AppTextStyles.f12w500.copyWith(
                  color: AppColors.primaryColorLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
