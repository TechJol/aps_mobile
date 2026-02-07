import 'dart:convert';

import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetTransactionsUsecase getTransactionsUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
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
    required this.deleteTransactionUsecase,
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

  void reset() {
    filteredPartners = [];
    partnerBalances = {};
    if (state is! MenuInitial) emit(MenuInitial());
  }

  void filterPartnersByType(int selectedTypeId) {
    if (state is! MenuPartnerDataSuccess) return;
    final current = state as MenuPartnerDataSuccess;
    final partners = current.partners ?? [];

    filteredPartners = partners
        .where((partner) => partner.type == selectedTypeId)
        .toList();

    emit(
      MenuPartnerDataSuccess(
        partners: partners,
        partnerTypes: current.partnerTypes,
        filteredPartners: filteredPartners,
      ),
    );
  }

  Future<void> getTransactionsWithAccounts({bool force = false}) async {
    final wasSuccess = state is MenuTransactionsWithAccountsSuccess;
    if (wasSuccess && !force) return;

    final companyId = await _companyId();
    if (!wasSuccess && !force) {
      final cached = await _readCachedTransactionsSnapshot(companyId);
      if (cached != null) {
        partnerBalances = cached.partnerBalances ?? {};
        emit(cached);
      } else {
        emit(MenuLoading());
      }
    }

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

    final transactions = (transactionsResult.getOrElse(() => []) as List)
        .map((e) => AllTransactionsModel.fromMap(e))
        .where((tx) => tx.company == companyId)
        .toList();

    final accounts = (accountsResult.getOrElse(() => []) as List)
        .map((e) => AccountModel.fromMap(e))
        .where((tx) => tx.company == companyId)
        .toList();

    final reasons = (reasonsResult.getOrElse(() => []) as List)
        .map((e) => IncomeExpenseReasons.fromMap(e))
        .where((reason) => reason.company == companyId)
        .toList();

    final partners = (partnersResult.getOrElse(() => []) as List)
        .map((e) => PartnersModel.fromMap(e))
        .where((partner) => partner.company == companyId)
        .toList();

    final partnerTypes = (partnerTypesResult.getOrElse(() => []) as List)
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

    await _writeCachedTransactionsSnapshot(
      companyId: companyId,
      transactions: transactions,
      accounts: accounts,
      reasons: reasons,
      partners: partners,
      partnerTypes: partnerTypes,
    );
  }

  Future<void> getPartnerData({bool force = false}) async {
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

    final partners = (partnersResult.getOrElse(() => []) as List)
        .map((e) => PartnersModel.fromMap(e))
        .toList();

    final types = (typesResult.getOrElse(() => []) as List)
        .map((e) => PartnerTypesModel.fromMap(e))
        .toList();

    final companyId = await _companyId();

    final filteredPartners = partners
        .where((partner) => partner.company == companyId)
        .toList();
    final filteredTypes = types
        .where((type) => type.company == companyId)
        .toList();

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
      final companyId = await _companyId();
      final filteredAccounts = accounts
          .where((account) => account.company == companyId)
          .toList();

      emit(MenuAccountsSuccess(accounts: filteredAccounts));
    });
  }

  Future<void> postAccount(AccountModel account) async {
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
      final reasons = (r as List)
          .map((e) => IncomeExpenseReasons.fromMap(e))
          .toList();
      final companyId = await _companyId();
      final filteredReasons = reasons
          .where((reason) => reason.company == companyId)
          .toList();

      emit(MenuReasonsSuccess(reasons: filteredReasons));
    });
  }

  Future<void> postReason(IncomeExpenseReasons reasons) async {
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
    final companyId = await _companyId();

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
      (r) async {
        final updated = trans.copyWith(id: id);
        emit(MenuTransactionUpdatedSuccess(updatedTransaction: updated));
        await getTransactionsWithAccounts(force: true);
      },
    );
  }

  Future<void> deleteTransaction(int id, {String? label}) async {
    final result = await deleteTransactionUsecase.call(id);
    await result.fold((l) async => emit(DeleteError(error: l)), (_) async {
      emit(
        MenuTransactionDeletedSuccess(
          transactionId: id,
          transactionLabel: label,
        ),
      );
      await getTransactionsWithAccounts(force: true);
    });
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

  Future<int?> _companyId() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getInt('companyId');
  }

  String _menuCacheKey(int? companyId) =>
      'menu_transactions_cache_${companyId ?? 0}';

  Future<void> _writeCachedTransactionsSnapshot({
    required int? companyId,
    required List<AllTransactionsModel> transactions,
    required List<AccountModel> accounts,
    required List<IncomeExpenseReasons> reasons,
    required List<PartnersModel> partners,
    required List<PartnerTypesModel> partnerTypes,
  }) async {
    final storage = await SharedPreferences.getInstance();
    final payload = <String, dynamic>{
      'transactions': transactions.map((e) => e.toMap()).toList(),
      'accounts': accounts.map((e) => e.toMap()).toList(),
      'reasons': reasons.map((e) => e.toMap()).toList(),
      'partners': partners.map((e) => e.toMap()).toList(),
      'partnerTypes': partnerTypes.map((e) => e.toMap()).toList(),
    };
    await storage.setString(_menuCacheKey(companyId), jsonEncode(payload));
  }

  Future<MenuTransactionsWithAccountsSuccess?> _readCachedTransactionsSnapshot(
    int? companyId,
  ) async {
    final storage = await SharedPreferences.getInstance();
    final raw = storage.getString(_menuCacheKey(companyId));
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      final transactions = ((decoded['transactions'] as List?) ?? [])
          .map(
            (e) => AllTransactionsModel.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
      final accounts = ((decoded['accounts'] as List?) ?? [])
          .map((e) => AccountModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      final reasons = ((decoded['reasons'] as List?) ?? [])
          .map(
            (e) => IncomeExpenseReasons.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
      final partners = ((decoded['partners'] as List?) ?? [])
          .map((e) => PartnersModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      final partnerTypes = ((decoded['partnerTypes'] as List?) ?? [])
          .map((e) => PartnerTypesModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      final balances = calculatePartnerBalances(transactions);
      return MenuTransactionsWithAccountsSuccess(
        transactions: transactions,
        accounts: accounts,
        reasons: reasons,
        partners: partners,
        partnerTypes: partnerTypes,
        partnerBalances: balances,
      );
    } catch (_) {
      return null;
    }
  }
}
