import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final GetPartnersUsecase getPartnersUsecase;
  final DeletePartnerUsecase deletePartnerUsecase;
  final PostPartnerUsecase postPartnerUsecase;
  final UpdatePartnerUsecase updatePartnerUsecase;
  final GetPartnerTypesUsecase getPartnerTypesUsecase;
  final PostPartnerTypeUsecase postPartnerTypeUsecase;
  final DeletePartnerTypeUsecase deletePartnerTypeUsecase;
  final UpdatePartnerTypeUsecase updatePartnerTypeUsecase;
  final PostAccountUsecase postAccountUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final UpdateAccountUsecase updateAccountUsecase;
  final GetAccountsUsecase getAccountsUsecase;
  final GetReasonsUsecase getReasonsUsecase;
  final PostReasonUsecase postReasonUsecase;
  final UpdateReasonUsecase updateReasonUsecase;
  final DeleteReasonUsecase deleteReasonUsecase;

  List<PartnersModel> partners = [];
  List<PartnerTypesModel> partnerTypes = [];

  MenuCubit({
    required this.getTransactionsUsecase,
    required this.updateTransactionUsecase,
    required this.getPartnersUsecase,
    required this.deletePartnerUsecase,
    required this.postPartnerUsecase,
    required this.updatePartnerUsecase,
    required this.getPartnerTypesUsecase,
    required this.postPartnerTypeUsecase,
    required this.deletePartnerTypeUsecase,
    required this.updatePartnerTypeUsecase,
    required this.postAccountUsecase,
    required this.deleteAccountUsecase,
    required this.updateAccountUsecase,
    required this.getAccountsUsecase,
    required this.getReasonsUsecase,
    required this.postReasonUsecase,
    required this.updateReasonUsecase,
    required this.deleteReasonUsecase,
  }) : super(MenuInitial());

  Future<void> getTransactionsWithAccounts() async {
    emit(MenuLoading());

    final transactionsResult = await getTransactionsUsecase();
    final accountsResult = await getAccountsUsecase();
    final reasonsResult = await getReasonsUsecase();
    final partnersResult = await getPartnersUsecase();

    if (transactionsResult.isLeft()) {
      transactionsResult.fold(
        (l) => emit(MenuError(message: l.message)),
        (_) {},
      );
      return;
    }

    if (accountsResult.isLeft()) {
      accountsResult.fold((l) => emit(MenuError(message: l.message)), (_) {});
      return;
    }

    if (reasonsResult.isLeft()) {
      reasonsResult.fold((l) => emit(MenuError(message: l.message)), (_) {});
      return;
    }

    if (partnersResult.isLeft()) {
      partnersResult.fold((l) => emit(MenuError(message: l.message)), (_) {});
      return;
    }

    final transactions =
        (transactionsResult.getOrElse(() => []) as List)
            .map((e) => AllTransactionsModel.fromMap(e))
            .toList();

    final accounts =
        (accountsResult.getOrElse(() => []) as List)
            .map((e) => AccountModel.fromMap(e))
            .toList();

    final reasons =
        (reasonsResult.getOrElse(() => []) as List)
            .map((e) => IncomeExpenseReasons.fromMap(e))
            .toList();

    final partners =
        (partnersResult.getOrElse(() => []) as List)
            .map((e) => PartnersModel.fromMap(e))
            .toList();

    emit(
      MenuTransactionsWithAccountsSuccess(
        transactions: transactions,
        accounts: accounts,
        reasons: reasons,
        partners: partners,
      ),
    );
  }

  Future<void> getAccounts() async {
    emit(MenuLoading());
    final result = await getAccountsUsecase();
    result.fold((l) => emit(MenuError(message: l.message)), (r) {
      final accounts = (r as List).map((e) => AccountModel.fromMap(e)).toList();
      emit(MenuAccountsSuccess(accounts: accounts));
    });
  }

  Future<void> postAccount(AccountModel account) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final acc = AccountModel(
      name: account.name,
      accountType: account.accountType,
      currency: account.currency,
      company: companyId,
    );

    final result = await postAccountUsecase.call(acc);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при добавлении: ${l.toString()}')),
      (r) => getAccounts(),
    );
  }

  Future<void> deleteAccount(int id) async {
    final result = await deleteAccountUsecase.call(id);
    result.fold((l) => emit(DeleteError(error: l)), (r) => getAccounts());
  }

  Future<void> updateAccount(AccountModel account, int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final acc = AccountModel(
      name: account.name,
      accountType: account.accountType,
      currency: account.currency,
      company: companyId,
    );

    final result = await updateAccountUsecase.call(acc, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {},
    );
  }

  Future<void> getReasons() async {
    emit(MenuLoading());
    final result = await getReasonsUsecase();
    result.fold((l) => emit(MenuError(message: l.message)), (r) {
      final reasons =
          (r as List).map((e) => IncomeExpenseReasons.fromMap(e)).toList();
      emit(MenuReasonsSuccess(reasons: reasons));
    });
  }

  Future<void> postReason(IncomeExpenseReasons reasons) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = IncomeExpenseReasons(
      name: reasons.name,
      type: reasons.type,
      company: companyId,
    );

    final result = await postReasonUsecase.call(part);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при добавлении: ${l.toString()}')),
      (r) => getReasons(),
    );
  }

  Future<void> updateReason(IncomeExpenseReasons reasons, int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = IncomeExpenseReasons(
      name: reasons.name,
      type: reasons.type,
      company: companyId,
    );

    final result = await updateReasonUsecase.call(part, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {},
    );
  }

  Future<void> deleteReason(int id) async {
    final result = await deleteReasonUsecase.call(id);
    result.fold((l) => emit(DeleteError(error: l)), (r) => getReasons());
  }

  // Загрузка данных о партнерах и типах партнеров
  Future<void> getPartnerData() async {
    emit(MenuLoading());

    final partnersResult = await getPartnersUsecase();
    final typesResult = await getPartnerTypesUsecase();

    if (partnersResult.isLeft()) {
      partnersResult.fold((l) => emit(MenuError(message: l.message)), (_) {});
      return;
    }

    if (typesResult.isLeft()) {
      typesResult.fold((l) => emit(MenuError(message: l.message)), (_) {});
      return;
    }

    final partners =
        (partnersResult.getOrElse(() => []) as List)
            .map((e) => PartnersModel.fromMap(e))
            .toList();

    final types =
        (typesResult.getOrElse(() => []) as List)
            .map((e) => PartnerTypesModel.fromMap(e))
            .toList();

    this.partners = partners;
    partnerTypes = types;

    // Передаем данные о партнерах и типах
    emit(MenuPartnerDataSuccess(partners: partners, partnerTypes: types));
  }

  void filterPartnersByType(int selectedType) {
    // Фильтруем партнеров по выбранному типу
    final filtered =
        partners
            .where(
              (partner) => partner.type == selectedType,
            ) // Сравниваем строковые значения типа
            .toList();

    print('Filtered Partners: $filtered'); // Логируем отфильтрованные данные

    // Эмитим успешное состояние с отфильтрованными партнерами
    emit(
      MenuPartnerDataSuccess(
        partners: partners,
        partnerTypes: partnerTypes,
        filteredPartners: filtered,
      ),
    );
  }

  Future<void> deletePartner(int id) async {
    final result = await deletePartnerUsecase.call(id);
    result.fold((l) => emit(DeleteError(error: l)), (r) => getPartnerData());
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
        emit(PartnerUpdated());
        getPartnerData();
      },
    );
  }

  Future<void> updatePartner(PartnersModel partner, int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = PartnersModel(
      name: partner.name,
      contactInfo: partner.contactInfo,
      type: partner.type,
      company: companyId,
    );

    final result = await updatePartnerUsecase.call(part, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {
        emit(PartnerUpdated());
        getPartnerData();
      },
    );
  }

  Future<void> postPartnerType(PartnerTypesModel partnerType) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = PartnerTypesModel(name: partnerType.name, company: companyId);

    final result = await postPartnerTypeUsecase.call(part);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при добавлении: ${l.toString()}')),
      (r) => getPartnerData(),
    );
  }

  Future<void> deletePartnerType(int id) async {
    final result = await deletePartnerTypeUsecase.call(id);
    result.fold((l) => emit(DeleteError(error: l)), (r) => getPartnerData());
  }

  Future<void> updatePartnerType(PartnerTypesModel partnerType, int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = PartnerTypesModel(name: partnerType.name, company: companyId);

    final result = await updatePartnerTypeUsecase.call(part, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {},
    );
  }

  Future<void> updateTransaction(
    AllTransactionsModel transaction,
    int id,
  ) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final trans = AllTransactionsModel(
      amount: transaction.amount,
      date: transaction.date,
      incomeExpenseReason: transaction.incomeExpenseReason,
      kgsCurrencyAmount: transaction.kgsCurrencyAmount,
      partner: transaction.partner,
      transactionType: transaction.transactionType,
      description: transaction.description,
      company: companyId,
      currency: transaction.currency,
      account: transaction.account,
      partners: transaction.partners,
    );
    final result = await updateTransactionUsecase.call(trans, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {},
    );
  }
}
