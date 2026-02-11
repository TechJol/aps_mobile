import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit({
    required this.addIncomeUsecase,
    required this.getAccountUsecase,
    required this.getIncomeExpenseReasonUsecase,
    required this.getStoredCompanyIdUsecase,
  }) : super(const IncomeState());

  final AddIncomeUsecase addIncomeUsecase;
  final GetAccountUsecase getAccountUsecase;
  final GetIncomeExpenseReasonUsecase getIncomeExpenseReasonUsecase;
  final GetStoredCompanyIdUsecase getStoredCompanyIdUsecase;

  Future<void> addIncome(IncomeAndComeoutModel income) async {
    final companyId = await getStoredCompanyIdUsecase();

    final inc = IncomeAndComeoutModel(
      account: income.account,
      amount: income.amount,
      date: income.date,
      currency: income.currency,
      company: companyId,
      transactionType: income.transactionType,
      description: income.description,
      kgsCurrencyAmount: income.kgsCurrencyAmount,
      incomeExpenseReason: income.incomeExpenseReason,
      partner: income.partner,
      partners: income.partners,
    );
    emit(state.copyWith(isLoading: true, incomeSaved: false, error: null));
    final result = await addIncomeUsecase(inc);
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, error: l.message)),
      (r) => emit(state.copyWith(isLoading: false, incomeSaved: true)),
    );
  }

  Future<void> getAccount() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await getAccountUsecase();
    res.fold((l) => emit(state.copyWith(isLoading: false, error: l.message)), (
      r,
    ) async {
      final accounts = (r as List)
          .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
          .toList();

      final companyId = await getStoredCompanyIdUsecase();

      final filteredAccounts = accounts
          .where((account) => account.company == companyId)
          .toList();

      emit(state.copyWith(isLoading: false, accounts: filteredAccounts));
    });
  }

  Future<void> getIncomeExpenseReasons() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await getIncomeExpenseReasonUsecase();
    res.fold((l) => emit(state.copyWith(isLoading: false, error: l.message)), (
      r,
    ) async {
      final reasons = (r as List)
          .map((e) => IncomeExpenseReasons.fromMap(e as Map<String, dynamic>))
          .toList();

      final companyId = await getStoredCompanyIdUsecase();

      final filteredReasons = reasons
          .where((reason) => reason.company == companyId)
          .toList();

      emit(state.copyWith(isLoading: false, reasons: filteredReasons));
    });
  }

  void preloadFormData({
    required List<AccountModel> accounts,
    required List<IncomeExpenseReasons> reasons,
    required List<PartnerTypesModel> partnerTypes,
    required List<PartnersModel> partners,
  }) {
    emit(
      state.copyWith(
        accounts: accounts,
        reasons: reasons,
        partnerTypes: partnerTypes,
        partners: partners,
        isLoading: false,
        error: null,
      ),
    );
  }

  void resetState() {
    emit(state.copyWith(incomeSaved: false, error: null));
  }

  void clearAll() {
    emit(const IncomeState());
  }
}
