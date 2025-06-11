import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(state.copyWith(isLoading: true, incomeSaved: false, error: null));
    final result = await addIncomeUsecase(income);
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
    ) {
      final accounts =
          (r as List)
              .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
              .toList();
      emit(state.copyWith(isLoading: false, accounts: accounts));
    });
  }

  Future<void> getIncomeExpenseReasons() async {
    emit(state.copyWith(isLoading: true, error: null));
    final res = await getIncomeExpenseReasonUsecase();
    res.fold((l) => emit(state.copyWith(isLoading: false, error: l.message)), (
      r,
    ) {
      final reasons =
          (r as List)
              .map(
                (e) => IncomeExpenseReasons.fromMap(e as Map<String, dynamic>),
              )
              .toList();
      emit(state.copyWith(isLoading: false, reasons: reasons));
    });
  }
}
