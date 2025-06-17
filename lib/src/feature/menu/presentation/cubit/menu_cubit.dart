import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final GetPartnersUsecase getPartnersUsecase;
  final DeletePartnerUsecase deletePartnerUsecase;
  final PostPartnerUsecase postPartnerUsecase;
  final UpdatePartnerUsecase updatePartnerUsecase;
  MenuCubit({
    required this.getTransactionsUsecase,
    required this.getPartnersUsecase,
    required this.deletePartnerUsecase,
    required this.postPartnerUsecase,
    required this.updatePartnerUsecase,
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
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');
    final part = PartnersModel(
      name: partner.name,
      contactInfo: partner.contactInfo,
      type: partner.type,
      company: companyId,
    );

    final result = await postPartnerUsecase.call(part);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при добавлении: ${l.toString()}')),
      (r) {
        getPartners(); // перезагружаем список после добавления
      },
    );
  }

  Future<void> updatePartner(PartnersModel partner) async {
    final result = await updatePartnerUsecase.call(partner);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {
        getPartners(); // перезагружаем список после обновления
      },
    );
  }
}
