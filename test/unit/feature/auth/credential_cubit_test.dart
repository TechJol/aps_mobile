import 'package:aps_mobile/src/core/error/failure.dart';
import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoginUsecase extends Mock implements LoginUsecase {}

class _MockRegisterUsecase extends Mock implements RegisterUsecase {}

class _MockLogoutUsecase extends Mock implements LogoutUsecase {}

class _MockGetUserByIdUsecase extends Mock implements GetUserByIdUsecase {}

class _MockDeleteUserByIdUsecase extends Mock implements DeleteUserByIdUsecase {}

class _MockGetStoredUserIdUsecase extends Mock
    implements GetStoredUserIdUsecase {}

void main() {
  late _MockLoginUsecase loginUsecase;
  late _MockRegisterUsecase registerUsecase;
  late _MockLogoutUsecase logoutUsecase;
  late _MockGetUserByIdUsecase getUserByIdUsecase;
  late _MockDeleteUserByIdUsecase deleteUserByIdUsecase;
  late _MockGetStoredUserIdUsecase getStoredUserIdUsecase;
  late CredentialCubit cubit;

  setUp(() {
    loginUsecase = _MockLoginUsecase();
    registerUsecase = _MockRegisterUsecase();
    logoutUsecase = _MockLogoutUsecase();
    getUserByIdUsecase = _MockGetUserByIdUsecase();
    deleteUserByIdUsecase = _MockDeleteUserByIdUsecase();
    getStoredUserIdUsecase = _MockGetStoredUserIdUsecase();

    cubit = CredentialCubit(
      loginUsecase: loginUsecase,
      registerUsecase: registerUsecase,
      logoutUsecase: logoutUsecase,
      getUserByIdUsecase: getUserByIdUsecase,
      deleteUserByIdUsecase: deleteUserByIdUsecase,
      getStoredUserIdUsecase: getStoredUserIdUsecase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<CredentialCubit, CredentialState>(
    'login emits loading then success',
    build: () {
      when(
        () => loginUsecase.call(username: 'user', password: 'pass'),
      ).thenAnswer((_) async => right(const AuthSession()));
      return cubit;
    },
    act: (cubit) => cubit.login('user', 'pass'),
    expect: () => [isA<CredentialLoading>(), isA<CredentialSuccess>()],
  );

  blocTest<CredentialCubit, CredentialState>(
    'login emits loading then failure when usecase fails',
    build: () {
      when(
        () => loginUsecase.call(username: 'user', password: 'bad'),
      ).thenAnswer((_) async => left(const Failure('invalid credentials')));
      return cubit;
    },
    act: (cubit) => cubit.login('user', 'bad'),
    expect: () => [isA<CredentialLoading>(), isA<CredentialFailure>()],
  );

  blocTest<CredentialCubit, CredentialState>(
    'getUserById emits loading then user loaded',
    build: () {
      when(() => getStoredUserIdUsecase.call()).thenAnswer((_) async => 11);
      when(() => getUserByIdUsecase.call(11)).thenAnswer(
        (_) async => right(const AuthEntity(username: 'user', password: 'p')),
      );
      return cubit;
    },
    act: (cubit) => cubit.getUserById(),
    expect: () => [isA<CredentialLoading>(), isA<CredentialUserLoaded>()],
  );

  blocTest<CredentialCubit, CredentialState>(
    'deleteUserById emits loading then success when delete and logout succeed',
    build: () {
      when(() => getStoredUserIdUsecase.call()).thenAnswer((_) async => 3);
      when(() => deleteUserByIdUsecase.call(3)).thenAnswer(
        (_) async => right(unit),
      );
      when(() => logoutUsecase.call()).thenAnswer((_) async => right(unit));
      return cubit;
    },
    act: (cubit) => cubit.deleteUserById(),
    expect: () => [isA<CredentialLoading>(), isA<CredentialSuccess>()],
  );
}
