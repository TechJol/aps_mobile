import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final AddIncomeUsecase usecase;
  IncomeCubit({required this.usecase}) : super(IncomeInitial());

  Future<void> addIncome(IncomeAndComeoutModel income) async {
    emit(IncomeLoading());
    final result = await usecase(income);
    result.fold(
      (l) => emit(IncomeError(message: l.message)),
      (r) => emit(IncomeSuccess()),
    );
  }
}
