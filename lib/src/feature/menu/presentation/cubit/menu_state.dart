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
