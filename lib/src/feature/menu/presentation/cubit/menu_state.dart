part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuSuccess extends MenuState {
  final List<AllTransactionsModel> transactions;
  const MenuSuccess({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

final class MenuError extends MenuState {
  final String message;
  const MenuError({required this.message});

  @override
  List<Object> get props => [message];
}

final class DeleteError extends MenuState {
  final Object error;
  const DeleteError({required this.error});

  @override
  List<Object> get props => [error];
}

final class MenuPartnerSuccess extends MenuState {
  final List<PartnersModel> partners;
  const MenuPartnerSuccess({required this.partners});

  @override
  List<Object> get props => [partners];
}

final class MenuPartnerTypesSuccess extends MenuState {
  final List<PartnerTypesModel> types;
  const MenuPartnerTypesSuccess({required this.types});

  @override
  List<Object> get props => [types];
}

final class MenuPartnerDataSuccess extends MenuState {
  final List<PartnersModel>? partners;
  final List<PartnerTypesModel>? partnerTypes;

  const MenuPartnerDataSuccess({
    required this.partners,
    required this.partnerTypes,
  });

  @override
  List<Object> get props => [partners ?? [], partnerTypes ?? []];
}

final class MenuAccountsSuccess extends MenuState {
  final List<AccountModel> accounts;
  const MenuAccountsSuccess({required this.accounts});

  @override
  List<Object> get props => [accounts];
}

final class MenuReasonsSuccess extends MenuState {
  final List<IncomeExpenseReasons> reasons;
  const MenuReasonsSuccess({required this.reasons});

  @override
  List<Object> get props => [reasons];
}

final class PartnerUpdated extends MenuState {}

final class MenuTransactionsWithAccountsSuccess extends MenuState {
  final List<AllTransactionsModel> transactions;
  final List<AccountModel> accounts;
  final List<IncomeExpenseReasons> reasons;

  const MenuTransactionsWithAccountsSuccess({
    required this.transactions,
    required this.accounts,
    required this.reasons,
  });

  @override
  List<Object> get props => [transactions, accounts, reasons];
}
