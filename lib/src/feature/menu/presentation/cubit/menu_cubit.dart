import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
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

  List<PartnersModel> filteredPartners = [];
  Map<int, Decimal> partnerBalances = {};

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

  void filterPartnersByType(int selectedTypeId) {
    final allPartners = (state as MenuPartnerDataSuccess).partners;

    filteredPartners =
        allPartners!.where((partner) {
          return partner.type == selectedTypeId;
        }).toList();

    emit(
      MenuPartnerDataSuccess(
        partners: allPartners,
        partnerTypes: (state as MenuPartnerDataSuccess).partnerTypes,
        filteredPartners: filteredPartners,
      ),
    );
  }

  Future<void> getTransactionsWithAccounts({bool force = false}) async {
    // Если данные уже есть и не просили форс‑обновление — ничего не делаем
    final wasSuccess = state is MenuTransactionsWithAccountsSuccess;
    if (wasSuccess && !force) return;

    // Тихий рефреш: при force не показываем лоадер, иначе показываем только
    // если ранее данных не было
    if (!wasSuccess && !force) emit(MenuLoading());

    final transactionsResult = await getTransactionsUsecase();
    final accountsResult = await getAccountsUsecase();
    final reasonsResult = await getReasonsUsecase();
    final partnersResult = await getPartnersUsecase();
    final partnerTypesResult = await getPartnerTypesUsecase();

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

    if (partnerTypesResult.isLeft()) {
      partnerTypesResult.fold(
        (l) => emit(MenuError(message: l.message)),
        (_) {},
      );
      return;
    }

    // Получаем companyId из SharedPreferences
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final transactions =
        (transactionsResult.getOrElse(() => []) as List)
            .map((e) => AllTransactionsModel.fromMap(e))
            // Фильтруем транзакции по companyId
            .where((tx) => tx.company == companyId)
            .toList();

    final accounts =
        (accountsResult.getOrElse(() => []) as List)
            .map((e) => AccountModel.fromMap(e))
            .where((tx) => tx.company == companyId)
            .toList();

    final reasons =
        (reasonsResult.getOrElse(() => []) as List)
            .map((e) => IncomeExpenseReasons.fromMap(e))
            .where((reason) => reason.company == companyId)
            .toList();

    final partners =
        (partnersResult.getOrElse(() => []) as List)
            .map((e) => PartnersModel.fromMap(e))
            .where((partner) => partner.company == companyId)
            .toList();

    final partnerTypes =
        (partnerTypesResult.getOrElse(() => []) as List)
            .map((e) => PartnerTypesModel.fromMap(e))
            .where((type) => type.company == companyId)
            .toList();

    final balances = calculatePartnerBalances(transactions);
    partnerBalances = balances;

    emit(
      MenuTransactionsWithAccountsSuccess(
        transactions: transactions,
        accounts: accounts,
        reasons: reasons,
        partners: partners,
        partnerTypes: partnerTypes,
        partnerBalances: balances,
      ),
    );
  }

  Future<void> getPartnerData({bool force = false}) async {
    // Если уже есть данные в Success — быстро эмитим нужное состояние
    if (!force && state is MenuTransactionsWithAccountsSuccess) {
      final s = state as MenuTransactionsWithAccountsSuccess;
      emit(
        MenuPartnerDataSuccess(
          partners: s.partners,
          partnerTypes: s.partnerTypes,
        ),
      );
      return;
    }

    final hadData =
        state is MenuPartnerDataSuccess ||
        state is MenuTransactionsWithAccountsSuccess;
    if (!hadData && !force) emit(MenuLoading());

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

    // Get companyId from SharedPreferences
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    // Filter partners and types by companyId
    final filteredPartners =
        partners.where((partner) => partner.company == companyId).toList();
    final filteredTypes =
        types.where((type) => type.company == companyId).toList();

    emit(
      MenuPartnerDataSuccess(
        partners: filteredPartners,
        partnerTypes: filteredTypes,
      ),
    );
  }

  Map<int, Decimal> calculatePartnerBalances(
    List<AllTransactionsModel> transactions,
  ) {
    Map<int, Decimal> balances = {};
    for (var tx in transactions) {
      final partnerId = tx.partners;
      if (partnerId != null) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
        balances[partnerId] = (balances[partnerId] ?? Decimal.zero) + amount;
      }
    }
    return balances;
  }

  Future<void> getAccounts() async {
    emit(MenuLoading());

    final result = await getAccountsUsecase();

    result.fold((l) => emit(MenuError(message: l.message)), (r) async {
      final accounts = (r as List).map((e) => AccountModel.fromMap(e)).toList();

      // Получаем companyId из SharedPreferences
      SharedPreferences storage = await SharedPreferences.getInstance();
      final companyId = storage.getInt('companyId');

      // Фильтруем счета по companyId
      final filteredAccounts =
          accounts.where((account) => account.company == companyId).toList();

      emit(MenuAccountsSuccess(accounts: filteredAccounts));
    });
  }

  Future<void> postAccount(AccountModel account) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final acc = AccountModel(
      name: account.name,
      accountType: account.accountType,
      currency: account.currency,
      company: companyId, // Обязательно указываем companyId
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

    result.fold((l) => emit(MenuError(message: l.message)), (r) async {
      final reasons =
          (r as List).map((e) => IncomeExpenseReasons.fromMap(e)).toList();

      // Get companyId from SharedPreferences
      SharedPreferences storage = await SharedPreferences.getInstance();
      final companyId = storage.getInt('companyId');

      // Filter reasons by companyId
      final filteredReasons =
          reasons.where((reason) => reason.company == companyId).toList();

      emit(MenuReasonsSuccess(reasons: filteredReasons));
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

  Future<void> deletePartner(int id) async {
    final result = await deletePartnerUsecase.call(id);
    result.fold(
      (l) => emit(DeleteError(error: l)),
      (r) => getPartnerData(force: true),
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
        emit(PartnerUpdated());
        getPartnerData(force: true);
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
        getPartnerData(force: true);
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
      (r) {
        emit(PartnerTypeUpdated());
        getPartnerData(force: true);
      },
    );
  }

  Future<void> deletePartnerType(int id) async {
    final result = await deletePartnerTypeUsecase.call(id);
    result.fold(
      (l) => emit(DeleteError(error: l)),
      (r) => getPartnerData(force: true),
    );
  }

  Future<void> updatePartnerType(PartnerTypesModel partnerType, int id) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final companyId = storage.getInt('companyId');

    final part = PartnerTypesModel(name: partnerType.name, company: companyId);

    final result = await updatePartnerTypeUsecase.call(part, id);
    result.fold(
      (l) => emit(MenuError(message: 'Ошибка при обновлении: ${l.toString()}')),
      (r) {
        emit(PartnerTypeUpdated());
        getPartnerData(force: true);
      },
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

  Future<void> updatePartnerInTransaction(
    AllTransactionsModel transaction,
    int? newPartnerId,
  ) async {
    if (newPartnerId == null) {
      emit(MenuError(message: 'Партнер не выбран'));
      return;
    }

    emit(MenuLoading());

    try {
      final updatedTransaction = transaction.copyWith(partners: newPartnerId);

      final updateResult = await updateTransactionUsecase(
        updatedTransaction,
        transaction.id!,
      );
      updateResult.fold(
        (l) => emit(
          MenuError(
            message: 'Ошибка при обновлении транзакции: \${l.toString()}',
          ),
        ),
        (r) {
          emit(
            MenuTransactionUpdatedSuccess(
              updatedTransaction: updatedTransaction,
            ),
          );
        },
      );
    } catch (e) {
      emit(MenuError(message: 'Ошибка: \${e.toString()}'));
    }
  }
}
