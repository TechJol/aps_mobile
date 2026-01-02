import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:equatable/equatable.dart';

class PaymentState extends Equatable {
  const PaymentState({
    this.plans = const [],
    this.periods = const [],
    this.isLoading = false,
    this.isStarting = false,
    this.error,
    this.selectedPlanId,
    this.selectedPeriodId,
  });

  final List<PlanEntity> plans;
  final List<PeriodEntity> periods;
  final bool isLoading;
  final bool isStarting;
  final String? error;
  final int? selectedPlanId;
  final int? selectedPeriodId;

  PaymentState copyWith({
    List<PlanEntity>? plans,
    List<PeriodEntity>? periods,
    bool? isLoading,
    bool? isStarting,
    String? error,
    int? selectedPlanId,
    int? selectedPeriodId,
  }) {
    return PaymentState(
      plans: plans ?? this.plans,
      periods: periods ?? this.periods,
      isLoading: isLoading ?? this.isLoading,
      isStarting: isStarting ?? this.isStarting,
      error: error,
      selectedPlanId: selectedPlanId ?? this.selectedPlanId,
      selectedPeriodId: selectedPeriodId ?? this.selectedPeriodId,
    );
  }

  @override
  List<Object?> get props => [
    plans,
    periods,
    isLoading,
    isStarting,
    error,
    selectedPlanId,
    selectedPeriodId,
  ];
}
