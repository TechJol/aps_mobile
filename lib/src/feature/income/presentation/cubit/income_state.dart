part of 'income_cubit.dart';

sealed class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object> get props => [];
}

final class IncomeInitial extends IncomeState {}

final class IncomeLoading extends IncomeState {}

final class IncomeSuccess extends IncomeState {}

final class IncomeError extends IncomeState {
  const IncomeError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
