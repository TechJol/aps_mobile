import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAddIncomeUsecase extends Mock implements AddIncomeUsecase {}

class _MockGetAccountUsecase extends Mock implements GetAccountUsecase {}

class _MockGetIncomeExpenseReasonUsecase extends Mock
    implements GetIncomeExpenseReasonUsecase {}

class _MockGetStoredCompanyIdUsecase extends Mock
    implements GetStoredCompanyIdUsecase {}

class _FakeIncomeAndComeoutModel extends Fake implements IncomeAndComeoutModel {}

void main() {
  late _MockAddIncomeUsecase addIncomeUsecase;
  late _MockGetAccountUsecase getAccountUsecase;
  late _MockGetIncomeExpenseReasonUsecase getIncomeExpenseReasonUsecase;
  late _MockGetStoredCompanyIdUsecase getStoredCompanyIdUsecase;
  late IncomeCubit cubit;

  setUpAll(() {
    registerFallbackValue(_FakeIncomeAndComeoutModel());
  });

  setUp(() {
    addIncomeUsecase = _MockAddIncomeUsecase();
    getAccountUsecase = _MockGetAccountUsecase();
    getIncomeExpenseReasonUsecase = _MockGetIncomeExpenseReasonUsecase();
    getStoredCompanyIdUsecase = _MockGetStoredCompanyIdUsecase();

    cubit = IncomeCubit(
      addIncomeUsecase: addIncomeUsecase,
      getAccountUsecase: getAccountUsecase,
      getIncomeExpenseReasonUsecase: getIncomeExpenseReasonUsecase,
      getStoredCompanyIdUsecase: getStoredCompanyIdUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  final income = IncomeAndComeoutModel(
    currency: 'KGS',
    date: '2026-01-01',
    amount: '1000',
    transactionType: 'income',
    account: 1,
    incomeExpenseReason: 1,
  );

  blocTest<IncomeCubit, IncomeState>(
    'addIncome emits loading then success',
    build: () {
      when(() => getStoredCompanyIdUsecase.call()).thenAnswer((_) async => 5);
      when(() => addIncomeUsecase.call(any())).thenAnswer((_) async => right(unit));
      return cubit;
    },
    act: (cubit) => cubit.addIncome(income),
    expect: () => [
      const IncomeState(isLoading: true, incomeSaved: false),
      const IncomeState(isLoading: false, incomeSaved: true),
    ],
  );

  blocTest<IncomeCubit, IncomeState>(
    'getAccount filters accounts by company id',
    build: () {
      when(() => getStoredCompanyIdUsecase.call()).thenAnswer((_) async => 5);
      when(() => getAccountUsecase.call()).thenAnswer(
        (_) async => right([
          {
            'id': 1,
            'name': 'A1',
            'account_type': 'cash',
            'currency': 'KGS',
            'company': 5,
          },
          {
            'id': 2,
            'name': 'A2',
            'account_type': 'cash',
            'currency': 'KGS',
            'company': 7,
          },
        ]),
      );
      return cubit;
    },
    act: (cubit) => cubit.getAccount(),
    verify: (cubit) {
      expect(cubit.state.accounts.length, 1);
      expect(cubit.state.accounts.first.company, 5);
    },
  );

  blocTest<IncomeCubit, IncomeState>(
    'getIncomeExpenseReasons emits error on failure',
    build: () {
      when(() => getIncomeExpenseReasonUsecase.call()).thenAnswer(
        (_) async => left(const Failure('network error')),
      );
      return cubit;
    },
    act: (cubit) => cubit.getIncomeExpenseReasons(),
    verify: (cubit) {
      expect(cubit.state.error, 'network error');
      expect(cubit.state.isLoading, isFalse);
    },
  );
}
