import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  CredentialCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getUserByIdUsecase,
    required this.deleteUserByIdUsecase,
    required this.getStoredUserIdUsecase,
  }) : super(CredentialInitial());

  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;
  final DeleteUserByIdUsecase deleteUserByIdUsecase;
  final GetStoredUserIdUsecase getStoredUserIdUsecase;

  void register(AuthEntity user) async {
    emit(CredentialLoading());
    try {
      final result = await registerUsecase.call(user);
      await result.fold((failure) async {
        final mapped = _mapFailure(failure.message);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
      }, (_) async {
        final loginResult = await loginUsecase.call(
          username: user.username,
          password: user.password,
        );
        loginResult.fold((failure) {
          final mapped = _mapFailure(failure.message);
          emit(
            CredentialFailure(
              errorMessage: mapped.message,
              errorCode: mapped.code,
            ),
          );
        }, (_) => emit(CredentialSuccess()));
      });
    } catch (e) {
      final mapped = _mapFailure(e.toString());
      emit(
        CredentialFailure(errorMessage: mapped.message, errorCode: mapped.code),
      );
    }
  }

  void login(String username, String password) async {
    emit(CredentialLoading());
    try {
      final result = await loginUsecase.call(
        username: username,
        password: password,
      );
      result.fold((failure) {
        final mapped = _mapFailure(failure.message);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
      }, (_) => emit(CredentialSuccess()));
    } catch (e) {
      final mapped = _mapFailure(e.toString());
      emit(
        CredentialFailure(errorMessage: mapped.message, errorCode: mapped.code),
      );
    }
  }

  void logout() async {
    emit(CredentialLoading());
    try {
      final result = await logoutUsecase.call();
      result.fold((failure) {
        final mapped = _mapFailure(failure.message);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
      }, (_) => emit(CredentialSuccess()));
    } catch (e) {
      final mapped = _mapFailure(e.toString());
      emit(
        CredentialFailure(errorMessage: mapped.message, errorCode: mapped.code),
      );
    }
  }

  void getUserById() async {
    emit(CredentialLoading());
    try {
      final id = await getStoredUserIdUsecase.call();
      if (id == null) {
        final mapped = _mapFailure(AuthErrorCodes.userIdMissing);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
        return;
      }
      final result = await getUserByIdUsecase.call(id);
      result.fold((failure) {
        final mapped = _mapFailure(failure.message);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
      }, (user) => emit(CredentialUserLoaded(user: user)));
    } catch (e) {
      final mapped = _mapFailure(e.toString());
      emit(
        CredentialFailure(errorMessage: mapped.message, errorCode: mapped.code),
      );
    }
  }

  void deleteUserById() async {
    emit(CredentialLoading());
    try {
      final id = await getStoredUserIdUsecase.call();
      if (id == null) {
        final mapped = _mapFailure(AuthErrorCodes.userIdMissing);
        emit(
          CredentialFailure(
            errorMessage: mapped.message,
            errorCode: mapped.code,
          ),
        );
        return;
      }
      final result = await deleteUserByIdUsecase.call(id);
      await result.fold(
        (failure) async {
          final mapped = _mapFailure(failure.message);
          emit(
            UserFailure(errorMessage: mapped.message, errorCode: mapped.code),
          );
        },
        (_) async {
          final logoutResult = await logoutUsecase.call();
          logoutResult.fold((failure) {
            final mapped = _mapFailure(failure.message);
            emit(
              CredentialFailure(
                errorMessage: mapped.message,
                errorCode: mapped.code,
              ),
            );
          }, (_) => emit(CredentialSuccess()));
        },
      );
    } catch (e) {
      final mapped = _mapFailure(e.toString());
      emit(
        CredentialFailure(errorMessage: mapped.message, errorCode: mapped.code),
      );
    }
  }

  ({String code, String message}) _mapFailure(String raw) {
    final normalized = raw.trim();
    final lower = normalized.toLowerCase();

    final companyText = t.auth.errors.companyExists.toLowerCase();
    final emailText = t.auth.errors.emailExists.toLowerCase();
    final usernameText = t.auth.errors.usernameExists.toLowerCase();

    if (normalized == AuthErrorCodes.companyExists ||
        lower.contains('main_company') ||
        lower.contains('company name') ||
        lower.contains('company') ||
        lower.contains(companyText)) {
      return (
        code: AuthErrorCodes.companyExists,
        message: t.auth.errors.companyExists,
      );
    }

    if (normalized == AuthErrorCodes.emailExists ||
        lower.contains('email') ||
        lower.contains('mail') ||
        lower.contains(emailText)) {
      return (
        code: AuthErrorCodes.emailExists,
        message: t.auth.errors.emailExists,
      );
    }

    if (normalized == AuthErrorCodes.usernameExists ||
        lower.contains('username') ||
        lower.contains('user name') ||
        lower.contains('users_user') ||
        lower.contains(usernameText)) {
      return (
        code: AuthErrorCodes.usernameExists,
        message: t.auth.errors.usernameExists,
      );
    }

    if (normalized == AuthErrorCodes.userIdMissing) {
      return (
        code: AuthErrorCodes.userIdMissing,
        message: t.auth.errors.unknown,
      );
    }

    if (normalized == AuthErrorCodes.unknown) {
      return (code: AuthErrorCodes.unknown, message: t.auth.errors.unknown);
    }

    return (code: AuthErrorCodes.unknown, message: normalized);
  }
}
