import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;

  CredentialCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
  }) : super(CredentialInitial());

  void register(AuthEntity user) async {
    emit(CredentialLoading());
    try {
      Either result = await registerUsecase.call(user);
      result.fold(
        (l) {
          emit(CredentialFailure(errorMessage: l));
        },
        (r) {
          emit(CredentialSuccess());
        },
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }

  void login(String username, String password) async {
    emit(CredentialLoading());
    try {
      Either result = await loginUsecase.call(
        username: username,
        password: password,
      );
      result.fold(
        (l) {
          emit(CredentialFailure(errorMessage: l));
        },
        (r) {
          emit(CredentialSuccess());
        },
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }

  void logout() async {
    emit(CredentialLoading());
    try {
      Either result = await logoutUsecase.call();
      result.fold(
        (l) {
          emit(CredentialFailure(errorMessage: l));
        },
        (r) {
          emit(CredentialSuccess());
        },
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }
}
