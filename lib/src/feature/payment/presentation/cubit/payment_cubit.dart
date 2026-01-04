import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:aps_mobile/src/feature/payment/presentation/cubit/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({
    required this.getPaymentPlansUsecase,
    required this.getPaymentPeriodsUsecase,
    required this.startPaymentUsecase,
    required this.getSubscriptionsUsecase,
  }) : super(const PaymentState());

  final GetPaymentPlansUsecase getPaymentPlansUsecase;
  final GetPaymentPeriodsUsecase getPaymentPeriodsUsecase;
  final StartPaymentUsecase startPaymentUsecase;
  final GetSubscriptionsUsecase getSubscriptionsUsecase;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, error: null));

    final plansResult = await getPaymentPlansUsecase();
    final periodsResult = await getPaymentPeriodsUsecase();

    if (plansResult.isLeft()) {
      plansResult.fold(
        (l) => emit(state.copyWith(isLoading: false, error: l.message)),
        (_) {},
      );
      return;
    }

    if (periodsResult.isLeft()) {
      periodsResult.fold(
        (l) => emit(state.copyWith(isLoading: false, error: l.message)),
        (_) {},
      );
      return;
    }

    List<PlanEntity> plans = [];
    List<PeriodEntity> periods = [];

    plansResult.fold((_) {}, (r) {
      plans = (r as List)
          .map((e) => PlanEntity.fromMap(e as Map<String, dynamic>))
          .toList();
    });
    periodsResult.fold((_) {}, (r) {
      periods = (r as List)
          .map((e) => PeriodEntity.fromMap(e as Map<String, dynamic>))
          .toList();
    });

    final selectedPlan = _selectDefaultPlan(plans);
    final selectedPeriodId = periods.isNotEmpty ? periods.first.id : null;

    emit(
      state.copyWith(
        isLoading: false,
        plans: plans,
        periods: periods,
        selectedPlanId: selectedPlan?.id,
        selectedPeriodId: selectedPeriodId,
      ),
    );
  }

  Future<void> fetchSubscriptions() async {
    if (state.isLoadingSubscriptions) return;
    emit(state.copyWith(isLoadingSubscriptions: true, error: null));

    final result = await getSubscriptionsUsecase();
    result.fold(
      (l) =>
          emit(state.copyWith(isLoadingSubscriptions: false, error: l.message)),
      (r) {
        final subscriptions = (r as List)
            .map((e) => SubscriptionEntity.fromMap(e as Map<String, dynamic>))
            .toList();
        emit(
          state.copyWith(
            isLoadingSubscriptions: false,
            subscriptions: subscriptions,
          ),
        );
      },
    );
  }

  void selectPeriod(int periodId) {
    if (periodId == state.selectedPeriodId) return;
    emit(state.copyWith(selectedPeriodId: periodId));
  }

  Future<void> startPayment() async {
    final planId = state.selectedPlanId;
    final periodId = state.selectedPeriodId;
    if (planId == null || periodId == null) return;

    emit(state.copyWith(isStarting: true, error: null));
    final result = await startPaymentUsecase(
      planId: planId,
      periodId: periodId,
    );
    result.fold(
      (l) => emit(state.copyWith(isStarting: false, error: l.message)),
      (r) {
        final data = r as Map<String, dynamic>;
        final paymentUrl = data['payment_url'] as String?;
        if (paymentUrl == null || paymentUrl.isEmpty) {
          emit(
            state.copyWith(isStarting: false, error: 'Payment URL отсутствует'),
          );
          return;
        }
        emit(state.copyWith(isStarting: false, paymentUrl: paymentUrl));
      },
    );
  }

  void clearPaymentUrl() {
    if (state.paymentUrl == null) return;
    emit(state.copyWith(clearPaymentUrl: true));
  }

  PlanEntity? _selectDefaultPlan(List<PlanEntity> plans) {
    if (plans.isEmpty) return null;
    return plans.firstWhere((plan) => plan.isActive, orElse: () => plans.first);
  }
}
