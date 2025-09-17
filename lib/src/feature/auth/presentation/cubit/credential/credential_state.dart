part of 'credential_cubit.dart';

sealed class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object?> get props => [];
}

final class CredentialInitial extends CredentialState {}

final class CredentialLoading extends CredentialState {}

final class CredentialSuccess extends CredentialState {}

final class CredentialFailure extends CredentialState {
  const CredentialFailure({
    required this.errorMessage,
    required this.errorCode,
  });

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

final class CredentialUserLoaded extends CredentialState {
  const CredentialUserLoaded({required this.user});

  final AuthEntity user;

  @override
  List<Object?> get props => [user];
}

final class UserFailure extends CredentialState {
  const UserFailure({required this.errorMessage, required this.errorCode});

  final String errorMessage;
  final String errorCode;

  @override
  List<Object?> get props => [errorMessage, errorCode];
}
