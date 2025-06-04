import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  CredentialCubit({required this.loginUsecase, required this.registerUsecase})
    : super(CredentialInitial());

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

  void login(AuthEntity user) async {
    emit(CredentialLoading());
    try {
      Either result = await loginUsecase.call(user);
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
