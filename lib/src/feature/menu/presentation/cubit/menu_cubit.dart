import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final GetPartnersUsecase getPartnersUsecase;
  final DeletePartnerUsecase deletePartnerUsecase;
  final PostPartnerUsecase postPartnerUsecase;
  MenuCubit({
    required this.getTransactionsUsecase,
    required this.getPartnersUsecase,
    required this.deletePartnerUsecase,
    required this.postPartnerUsecase,
  }) : super(MenuInitial());

  Future<void> getTransactions() async {
    emit(MenuLoading());
    final result = await getTransactionsUsecase();
    result.fold((l) => emit(MenuError(message: l.message)), (r) {
      final transactions =
          (r as List).map((e) => AllTransactionsModel.fromMap(e)).toList();
      emit(MenuSuccess(transactions: transactions));
    });
  }

  Future<void> getPartners() async {
    emit(MenuLoading());
    final result = await getPartnersUsecase();
    result.fold((l) => emit(MenuError(message: l.message)), (r) {
      final partners =
          (r as List).map((e) => PartnersModel.fromMap(e)).toList();
      emit(MenuPartnerSuccess(partners: partners));
    });
  }

  Future<void> deletePartner(int id) async {
    final result = await deletePartnerUsecase.call(id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при удалении: ${l.toString()}')),
      (r) {
        getPartners(); // перезагружаем список после удаления
      },
    );
  }

  Future<void> postPartner(PartnersModel partner) async {
    final result = await postPartnerUsecase.call(partner);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при добавлении: ${l.toString()}')),
      (r) {
        getPartners(); // перезагружаем список после добавления
      },
    );
  }
}
