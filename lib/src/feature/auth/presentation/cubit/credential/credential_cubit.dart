import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;

  CredentialCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getUserByIdUsecase,
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

  void getUserById() async {
    emit(CredentialLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final id = pref.getInt('userId');
      Either result = await getUserByIdUsecase.call(id!);
      result.fold(
        (l) {
          emit(CredentialFailure(errorMessage: l));
        },
        (r) {
          // 💥 Здесь ты должен эмитить CredentialUserLoaded!
          final user = AuthModel.fromJson(r);
          emit(CredentialUserLoaded(user: user));
        },
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }
}
