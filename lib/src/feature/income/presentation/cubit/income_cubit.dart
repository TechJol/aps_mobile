import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final AddIncomeUsecase addIncomeUsecase;
  final GetAccountUsecase getAccountUsecase;
  final GetIncomeExpenseReasonUsecase getIncomeExpenseReasonUsecase;

  IncomeCubit({
    required this.addIncomeUsecase,
    required this.getAccountUsecase,
    required this.getIncomeExpenseReasonUsecase,
  }) : super(IncomeInitial());

  Future<void> addIncome(IncomeAndComeoutModel income) async {
    emit(IncomeLoading());
    final result = await addIncomeUsecase(income);
    result.fold(
      (l) => emit(IncomeError(message: l.message)),
      (r) => emit(IncomeSuccess()),
    );
  }

  Future<void> getAccount() async {
    emit(IncomeLoading());
    final result = await getAccountUsecase.call();
    result.fold((l) => emit(IncomeError(message: l.message)), (r) {
      final accounts =
          (r as List)
              .map((e) => AccountModel.fromMap(e as Map<String, dynamic>))
              .toList();
      emit(AccountLoaded(accounts: accounts));
    });
  }

  Future<void> getIncomeExpenseReasons() async {
    emit(IncomeLoading());
    final result = await getIncomeExpenseReasonUsecase.call();
    result.fold((l) => emit(IncomeError(message: l.message)), (r) {
      final reasons =
          (r as List)
              .map(
                (e) => IncomeExpenseReasons.fromMap(e as Map<String, dynamic>),
              )
              .toList();
      emit(IncomeExpenseReasonsLoaded(reasons: reasons));
    });
  }
}
