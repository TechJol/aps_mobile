import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsLoggedInUsecase isLoggedInUsecase;

  AuthCubit({required this.isLoggedInUsecase}) : super(AuthInitialState());

  void appStarted() async {
    var isLoggedIn = await isLoggedInUsecase.call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
