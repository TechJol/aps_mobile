part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object> get props => [];
}

final class CredentialInitial extends CredentialState {}

final class CredentialLoading extends CredentialState {}

final class CredentialSuccess extends CredentialState {}

final class CredentialFailure extends CredentialState {
  const CredentialFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
