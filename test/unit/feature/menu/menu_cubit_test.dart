import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetTransactionsUsecase extends Mock implements GetTransactionsUsecase {}

class _MockUpdateTransactionUsecase extends Mock
    implements UpdateTransactionUsecase {}

class _MockDeleteTransactionUsecase extends Mock
    implements DeleteTransactionUsecase {}

class _MockGetPartnersUsecase extends Mock implements GetPartnersUsecase {}

class _MockDeletePartnerUsecase extends Mock implements DeletePartnerUsecase {}

class _MockPostPartnerUsecase extends Mock implements PostPartnerUsecase {}

class _MockUpdatePartnerUsecase extends Mock implements UpdatePartnerUsecase {}

class _MockGetPartnerTypesUsecase extends Mock
    implements GetPartnerTypesUsecase {}

class _MockPostPartnerTypeUsecase extends Mock
    implements PostPartnerTypeUsecase {}

class _MockDeletePartnerTypeUsecase extends Mock
    implements DeletePartnerTypeUsecase {}

class _MockUpdatePartnerTypeUsecase extends Mock
    implements UpdatePartnerTypeUsecase {}

class _MockPostAccountUsecase extends Mock implements PostAccountUsecase {}

class _MockDeleteAccountUsecase extends Mock implements DeleteAccountUsecase {}

class _MockUpdateAccountUsecase extends Mock implements UpdateAccountUsecase {}

class _MockGetAccountsUsecase extends Mock implements GetAccountsUsecase {}

class _MockGetReasonsUsecase extends Mock implements GetReasonsUsecase {}

class _MockPostReasonUsecase extends Mock implements PostReasonUsecase {}

class _MockUpdateReasonUsecase extends Mock implements UpdateReasonUsecase {}

class _MockDeleteReasonUsecase extends Mock implements DeleteReasonUsecase {}

class _MockMenuLocalDataSource extends Mock implements MenuLocalDataSource {}
class _MockGetStoredCompanyIdUsecase extends Mock
    implements GetStoredCompanyIdUsecase {}

class _FakeMenuCacheSnapshot extends Fake implements MenuCacheSnapshot {}

void main() {
  late _MockGetTransactionsUsecase getTransactionsUsecase;
  late _MockUpdateTransactionUsecase updateTransactionUsecase;
  late _MockDeleteTransactionUsecase deleteTransactionUsecase;
  late _MockGetPartnersUsecase getPartnersUsecase;
  late _MockDeletePartnerUsecase deletePartnerUsecase;
  late _MockPostPartnerUsecase postPartnerUsecase;
  late _MockUpdatePartnerUsecase updatePartnerUsecase;
  late _MockGetPartnerTypesUsecase getPartnerTypesUsecase;
  late _MockPostPartnerTypeUsecase postPartnerTypeUsecase;
  late _MockDeletePartnerTypeUsecase deletePartnerTypeUsecase;
  late _MockUpdatePartnerTypeUsecase updatePartnerTypeUsecase;
  late _MockPostAccountUsecase postAccountUsecase;
  late _MockDeleteAccountUsecase deleteAccountUsecase;
  late _MockUpdateAccountUsecase updateAccountUsecase;
  late _MockGetAccountsUsecase getAccountsUsecase;
  late _MockGetReasonsUsecase getReasonsUsecase;
  late _MockPostReasonUsecase postReasonUsecase;
  late _MockUpdateReasonUsecase updateReasonUsecase;
  late _MockDeleteReasonUsecase deleteReasonUsecase;
  late _MockMenuLocalDataSource menuLocalDataSource;
  late _MockGetStoredCompanyIdUsecase getStoredCompanyIdUsecase;
  late MenuCubit cubit;

  setUpAll(() {
    registerFallbackValue(_FakeMenuCacheSnapshot());
  });

  setUp(() {
    getTransactionsUsecase = _MockGetTransactionsUsecase();
    updateTransactionUsecase = _MockUpdateTransactionUsecase();
    deleteTransactionUsecase = _MockDeleteTransactionUsecase();
    getPartnersUsecase = _MockGetPartnersUsecase();
    deletePartnerUsecase = _MockDeletePartnerUsecase();
    postPartnerUsecase = _MockPostPartnerUsecase();
    updatePartnerUsecase = _MockUpdatePartnerUsecase();
    getPartnerTypesUsecase = _MockGetPartnerTypesUsecase();
    postPartnerTypeUsecase = _MockPostPartnerTypeUsecase();
    deletePartnerTypeUsecase = _MockDeletePartnerTypeUsecase();
    updatePartnerTypeUsecase = _MockUpdatePartnerTypeUsecase();
    postAccountUsecase = _MockPostAccountUsecase();
    deleteAccountUsecase = _MockDeleteAccountUsecase();
    updateAccountUsecase = _MockUpdateAccountUsecase();
    getAccountsUsecase = _MockGetAccountsUsecase();
    getReasonsUsecase = _MockGetReasonsUsecase();
    postReasonUsecase = _MockPostReasonUsecase();
    updateReasonUsecase = _MockUpdateReasonUsecase();
    deleteReasonUsecase = _MockDeleteReasonUsecase();
    menuLocalDataSource = _MockMenuLocalDataSource();
    getStoredCompanyIdUsecase = _MockGetStoredCompanyIdUsecase();
    when(() => getStoredCompanyIdUsecase.call()).thenAnswer((_) async => 1);

    cubit = MenuCubit(
      getTransactionsUsecase: getTransactionsUsecase,
      updateTransactionUsecase: updateTransactionUsecase,
      deleteTransactionUsecase: deleteTransactionUsecase,
      getPartnersUsecase: getPartnersUsecase,
      deletePartnerUsecase: deletePartnerUsecase,
      postPartnerUsecase: postPartnerUsecase,
      updatePartnerUsecase: updatePartnerUsecase,
      getPartnerTypesUsecase: getPartnerTypesUsecase,
      postPartnerTypeUsecase: postPartnerTypeUsecase,
      deletePartnerTypeUsecase: deletePartnerTypeUsecase,
      updatePartnerTypeUsecase: updatePartnerTypeUsecase,
      postAccountUsecase: postAccountUsecase,
      deleteAccountUsecase: deleteAccountUsecase,
      updateAccountUsecase: updateAccountUsecase,
      getAccountsUsecase: getAccountsUsecase,
      getReasonsUsecase: getReasonsUsecase,
      postReasonUsecase: postReasonUsecase,
      updateReasonUsecase: updateReasonUsecase,
      deleteReasonUsecase: deleteReasonUsecase,
      menuLocalDataSource: menuLocalDataSource,
      getStoredCompanyIdUsecase: getStoredCompanyIdUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('calculatePartnerBalances sums by partners id', () {
    final balances = cubit.calculatePartnerBalances([
      AllTransactionsModel(
        currency: 'KGS',
        date: '2026-01-01',
        amount: '100',
        transactionType: 'income',
        account: 1,
        incomeExpenseReason: 1,
        partners: 10,
      ),
      AllTransactionsModel(
        currency: 'KGS',
        date: '2026-01-02',
        amount: '25',
        transactionType: 'income',
        account: 1,
        incomeExpenseReason: 1,
        partners: 10,
      ),
    ]);

    expect(balances[10], Decimal.parse('125'));
  });

  blocTest<MenuCubit, MenuState>(
    'getPartnerData emits filtered partner data by company',
    build: () {
      when(() => getPartnersUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 1, 'name': 'P1', 'company': 1, 'type': 7},
          {'id': 2, 'name': 'P2', 'company': 2, 'type': 7},
        ]),
      );
      when(() => getPartnerTypesUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 7, 'name': 'Client', 'company': 1},
          {'id': 8, 'name': 'Staff', 'company': 2},
        ]),
      );
      return cubit;
    },
    act: (cubit) => cubit.getPartnerData(force: true),
    verify: (cubit) {
      final s = cubit.state as MenuPartnerDataSuccess;
      expect(s.partners?.length, 1);
      expect(s.partnerTypes?.length, 1);
      expect(s.partners?.first.company, 1);
    },
  );

  blocTest<MenuCubit, MenuState>(
    'getTransactionsWithAccounts emits success and saves snapshot',
    build: () {
      when(
        () => menuLocalDataSource.getTransactionsSnapshot(companyId: 1),
      ).thenAnswer((_) async => null);
      when(() => getTransactionsUsecase.call()).thenAnswer(
        (_) async => right([
          {
            'id': 1,
            'currency': 'KGS',
            'date': '2026-01-01',
            'amount': '100',
            'transaction_type': 'income',
            'account': 1,
            'income_expense_reason': 1,
            'company': 1,
            'partners': 10,
          },
        ]),
      );
      when(() => getAccountsUsecase.call()).thenAnswer(
        (_) async => right([
          {
            'id': 1,
            'name': 'Cash',
            'account_type': 'cash',
            'currency': 'KGS',
            'company': 1,
          },
        ]),
      );
      when(() => getReasonsUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 1, 'name': 'Sale', 'type': 'income', 'company': 1},
        ]),
      );
      when(() => getPartnersUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 10, 'name': 'Partner', 'company': 1, 'type': 7},
        ]),
      );
      when(() => getPartnerTypesUsecase.call()).thenAnswer(
        (_) async => right([
          {'id': 7, 'name': 'Client', 'company': 1},
        ]),
      );
      when(
        () => menuLocalDataSource.saveTransactionsSnapshot(
          companyId: 1,
          snapshot: any(named: 'snapshot'),
        ),
      ).thenAnswer((_) async {});
      return cubit;
    },
    act: (cubit) => cubit.getTransactionsWithAccounts(force: true),
    verify: (_) {
      verify(
        () => menuLocalDataSource.saveTransactionsSnapshot(
          companyId: 1,
          snapshot: any(named: 'snapshot'),
        ),
      ).called(1);
    },
  );
}
