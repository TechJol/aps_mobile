import 'package:aps_mobile/src/feature/feature.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  final LogoutUsecase logoutUsecase;
  final GetUserByIdUsecase getUserByIdUsecase;
  final DeleteUserByIdUsecase deleteUserByIdUsecase;

  CredentialCubit({
    required this.loginUsecase,
    required this.registerUsecase,
    required this.logoutUsecase,
    required this.getUserByIdUsecase,
    required this.deleteUserByIdUsecase,
  }) : super(CredentialInitial());

  void register(AuthEntity user) async {
    emit(CredentialLoading());
    try {
      final result = await registerUsecase.call(user);
      result.fold(
        (l) => emit(CredentialFailure(errorMessage: l.message)),
        (r) => emit(CredentialSuccess()),
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }

  void login(String username, String password) async {
    emit(CredentialLoading());
    try {
      final result = await loginUsecase.call(
        username: username,
        password: password,
      );
      result.fold(
        (l) => emit(CredentialFailure(errorMessage: l.message)),
        (r) => emit(CredentialSuccess()),
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }

  void logout() async {
    emit(CredentialLoading());
    try {
      final result = await logoutUsecase.call();
      result.fold(
        (l) => emit(CredentialFailure(errorMessage: l.message)),
        (r) => emit(CredentialSuccess()),
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
      if (id == null) {
        emit(const CredentialFailure(errorMessage: 'User ID is missing'));
        return;
      }
      final result = await getUserByIdUsecase.call(id);
      result.fold(
        (l) => emit(CredentialFailure(errorMessage: l.message)),
        (r) => emit(CredentialUserLoaded(user: r)),
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }

  void deleteUserById() async {
    emit(CredentialLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final id = pref.getInt('userId');
      if (id == null) {
        emit(const CredentialFailure(errorMessage: 'User ID is missing'));
        return;
      }
      final result = await deleteUserByIdUsecase.call(id);
      await result.fold(
        (l) async => emit(UserFailure(errorMessage: l.message)),
        (r) async {
          // Полный локальный logout (очистка access/refresh/userId/companyId)
          await logoutUsecase.call();
          emit(CredentialSuccess());
        },
      );
    } catch (e) {
      emit(CredentialFailure(errorMessage: e.toString()));
    }
  }
}
