import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/menu/data/models/all_transactions_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  MenuCubit({required this.getTransactionsUsecase}) : super(MenuInitial());

  Future<void> getTransactions() async {
    emit(MenuLoading());
    final result = await getTransactionsUsecase();
    result.fold((l) => emit(MenuError(message: l.message)), (r) {
      final transactions =
          (r as List).map((e) => AllTransactionsModel.fromMap(e)).toList();
      emit(MenuSuccess(transactions: transactions));
    });
  }
}
