import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:equatable/equatable.dart';

class PaymentState extends Equatable {
  const PaymentState({
    this.plans = const [],
    this.periods = const [],
    this.subscriptions = const [],
    this.isLoading = false,
    this.isStarting = false,
    this.isLoadingSubscriptions = false,
    this.error,
    this.paymentUrl,
    this.selectedPlanId,
    this.selectedPeriodId,
  });

  final List<PlanEntity> plans;
  final List<PeriodEntity> periods;
  final List<SubscriptionEntity> subscriptions;
  final bool isLoading;
  final bool isStarting;
  final bool isLoadingSubscriptions;
  final String? error;
  final String? paymentUrl;
  final int? selectedPlanId;
  final int? selectedPeriodId;

  SubscriptionEntity? get activeSubscription {
    for (final subscription in subscriptions) {
      if (subscription.isActive) return subscription;
    }
    return null;
  }

  PaymentState copyWith({
    List<PlanEntity>? plans,
    List<PeriodEntity>? periods,
    List<SubscriptionEntity>? subscriptions,
    bool? isLoading,
    bool? isStarting,
    bool? isLoadingSubscriptions,
    String? error,
    String? paymentUrl,
    bool clearPaymentUrl = false,
    int? selectedPlanId,
    int? selectedPeriodId,
  }) {
    return PaymentState(
      plans: plans ?? this.plans,
      periods: periods ?? this.periods,
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      isStarting: isStarting ?? this.isStarting,
      isLoadingSubscriptions:
          isLoadingSubscriptions ?? this.isLoadingSubscriptions,
      error: error,
      paymentUrl: clearPaymentUrl ? null : paymentUrl ?? this.paymentUrl,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedPeriodId: selectedPeriodId ?? this.selectedPeriodId,
    );
  }

  @override
  List<Object?> get props => [
    plans,
    periods,
    subscriptions,
    isLoading,
    isStarting,
    isLoadingSubscriptions,
    error,
    paymentUrl,
    selectedPlanId,
    selectedPeriodId,
  ];
}
