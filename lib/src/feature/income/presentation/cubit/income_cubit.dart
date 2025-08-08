import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeCubit extends Cubit<IncomeState> {
  IncomeCubit({
    required this.addIncomeUsecase,
    required this.getAccountUsecase,
    required this.getIncomeExpenseReasonUsecase,
  }) : super(const IncomeState());

  final AddIncomeUsecase addIncomeUsecase;
  final GetAccountUsecase getAccountUsecase;
  final GetIncomeExpenseReasonUsecase getIncomeExpenseReasonUsecase;

  Future<void> addIncome(IncomeAndComeoutModel income) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    var companyId = storage.getInt('companyId');

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
      final accounts =
          (r as List)
              .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
              .toList();

      // Get companyId from SharedPreferences
      SharedPreferences storage = await SharedPreferences.getInstance();
      final companyId = storage.getInt('companyId');

      // Filter accounts by companyId
      final filteredAccounts =
          accounts.where((account) => account.company == companyId).toList();

      emit(state.copyWith(isLoading: false, accounts: filteredAccounts));
    });
  }

  Future<void> getIncomeExpenseReasons() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await getIncomeExpenseReasonUsecase();
    res.fold((l) => emit(state.copyWith(isLoading: false, error: l.message)), (
      r,
    ) async {
      final reasons =
          (r as List)
              .map(
                (e) => IncomeExpenseReasons.fromMap(e as Map<String, dynamic>),
              )
              .toList();

      // Get companyId from SharedPreferences
      SharedPreferences storage = await SharedPreferences.getInstance();
      final companyId = storage.getInt('companyId');

      // Filter reasons by companyId
      final filteredReasons =
          reasons.where((reason) => reason.company == companyId).toList();

      emit(state.copyWith(isLoading: false, reasons: filteredReasons));
    });
  }

  void resetState() {
    emit(state.copyWith(incomeSaved: false, error: null));
  }
}
