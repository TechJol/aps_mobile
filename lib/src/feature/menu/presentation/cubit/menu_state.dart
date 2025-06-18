part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuSuccess extends MenuState {
  const MenuSuccess({required this.transactions});

  final List<AllTransactionsModel> transactions;

  @override
  List<Object> get props => [transactions];
}

final class MenuError extends MenuState {
  const MenuError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class MenuPartnerSuccess extends MenuState {
  const MenuPartnerSuccess({required this.partners});

  final List<PartnersModel> partners;

  @override
  List<Object> get props => [partners];
}

final class DeleteError extends MenuState {
  const DeleteError({required this.error});

  final Object error;

  @override
  List<Object> get props => [error];
}

final class MenuPartnerTypesSuccess extends MenuState {
  const MenuPartnerTypesSuccess({required this.types});

  final List<PartnerTypesModel> types;

  @override
  List<Object> get props => [types];
}
