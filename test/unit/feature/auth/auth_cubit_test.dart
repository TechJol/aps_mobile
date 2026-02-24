import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockIsLoggedInUsecase extends Mock implements IsLoggedInUsecase {}

class _MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late _MockIsLoggedInUsecase isLoggedInUsecase;
  late _MockLogoutUsecase logoutUsecase;
  late AuthCubit cubit;

  setUp(() {
    isLoggedInUsecase = _MockIsLoggedInUsecase();
    logoutUsecase = _MockLogoutUsecase();
    cubit = AuthCubit(
      isLoggedInUsecase: isLoggedInUsecase,
      logoutUsecase: logoutUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<AuthCubit, AuthState>(
    'appStarted emits Authenticated when user is logged in',
    build: () {
      when(() => isLoggedInUsecase.call()).thenAnswer((_) async => true);
      return cubit;
    },
    act: (cubit) => cubit.appStarted(),
    expect: () => [isA<Authenticated>()],
  );

  blocTest<AuthCubit, AuthState>(
    'appStarted emits UnAuthenticated when user is not logged in',
    build: () {
      when(() => isLoggedInUsecase.call()).thenAnswer((_) async => false);
      return cubit;
    },
    act: (cubit) => cubit.appStarted(),
    expect: () => [isA<UnAuthenticated>()],
  );

  blocTest<AuthCubit, AuthState>(
    'logout emits UnAuthenticated',
    build: () {
      when(() => logoutUsecase.call()).thenAnswer((_) async => right(unit));
      return cubit;
    },
    act: (cubit) => cubit.logout(),
    expect: () => [isA<UnAuthenticated>()],
  );
}
