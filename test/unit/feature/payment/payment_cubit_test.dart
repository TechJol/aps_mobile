import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPaymentPlansUsecase extends Mock implements GetPaymentPlansUsecase {}

class _MockGetPaymentPeriodsUsecase extends Mock
    implements GetPaymentPeriodsUsecase {}

class _MockStartPaymentUsecase extends Mock implements StartPaymentUsecase {}

class _MockGetSubscriptionsUsecase extends Mock
    implements GetSubscriptionsUsecase {}

void main() {
  late _MockGetPaymentPlansUsecase getPaymentPlansUsecase;
  late _MockGetPaymentPeriodsUsecase getPaymentPeriodsUsecase;
  late _MockStartPaymentUsecase startPaymentUsecase;
  late _MockGetSubscriptionsUsecase getSubscriptionsUsecase;
  late PaymentCubit cubit;

  setUp(() {
    getPaymentPlansUsecase = _MockGetPaymentPlansUsecase();
    getPaymentPeriodsUsecase = _MockGetPaymentPeriodsUsecase();
    startPaymentUsecase = _MockStartPaymentUsecase();
    getSubscriptionsUsecase = _MockGetSubscriptionsUsecase();
    cubit = PaymentCubit(
      getPaymentPlansUsecase: getPaymentPlansUsecase,
      getPaymentPeriodsUsecase: getPaymentPeriodsUsecase,
      startPaymentUsecase: startPaymentUsecase,
      getSubscriptionsUsecase: getSubscriptionsUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<PaymentCubit, PaymentState>(
    'load emits data with selected defaults',
    build: () {
      when(() => getPaymentPlansUsecase.call()).thenAnswer(
        (_) async => right([
          {
            'id': 1,
            'name': 'Base',
            'price_per_month': 100,
            'is_active': false,
          },
          {
            'id': 2,
            'name': 'Pro',
            'price_per_month': 200,
            'is_active': true,
          },
        ]),
      );
      when(() => getPaymentPeriodsUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 10, 'name': '1m', 'months': 1, 'discount_percent': 0},
        ]),
      );
      return cubit;
    },
    act: (cubit) => cubit.load(),
    verify: (cubit) {
      expect(cubit.state.plans.length, 2);
      expect(cubit.state.periods.length, 1);
      expect(cubit.state.selectedPlanId, 2);
      expect(cubit.state.selectedPeriodId, 10);
      expect(cubit.state.isLoading, isFalse);
    },
  );

  blocTest<PaymentCubit, PaymentState>(
    'startPayment stores paymentUrl on success',
    build: () {
      when(() => startPaymentUsecase.call(planId: 2, periodId: 10)).thenAnswer(
        (_) async => right({'payment_url': 'https://pay.example'}),
      );
      return cubit;
    },
    seed: () => const PaymentState(selectedPlanId: 2, selectedPeriodId: 10),
    act: (cubit) => cubit.startPayment(),
    verify: (cubit) {
      expect(cubit.state.paymentUrl, 'https://pay.example');
      expect(cubit.state.isStarting, isFalse);
    },
  );

  blocTest<PaymentCubit, PaymentState>(
    'fetchSubscriptions emits error when usecase fails',
    build: () {
      when(
        () => getSubscriptionsUsecase.call(),
      ).thenAnswer((_) async => left(const Failure('subs error')));
      return cubit;
    },
    act: (cubit) => cubit.fetchSubscriptions(),
    verify: (cubit) {
      expect(cubit.state.error, 'subs error');
      expect(cubit.state.isLoadingSubscriptions, isFalse);
    },
  );
}
