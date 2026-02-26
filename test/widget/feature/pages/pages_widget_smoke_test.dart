import 'package:aps_mobile/src/core/theme/theme_cubit.dart';
import 'package:aps_mobile/src/feature/account/presentation/pages/account_page.dart';
import 'package:aps_mobile/src/feature/auth/auth.dart';
import 'package:aps_mobile/src/feature/home/presentation/pages/home_page.dart';
import 'package:aps_mobile/src/feature/menu/presentation/cubit/menu_cubit.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/menu_page.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/profile_page.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/settings_app_page.dart';
import 'package:aps_mobile/src/feature/operation/presentation/pages/operation_page.dart';
import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMenuCubit extends MockCubit<MenuState> implements MenuCubit {}

class MockCredentialCubit extends MockCubit<CredentialState>
    implements CredentialCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}

class MockPaymentCubit extends MockCubit<PaymentState> implements PaymentCubit {}

Widget _wrapWithApp({
  required Widget child,
  required List<BlocProvider> providers,
}) {
  return MaterialApp(
    home: MultiBlocProvider(providers: providers, child: child),
  );
}

void main() {
  late MockMenuCubit menuCubit;
  late MockCredentialCubit credentialCubit;
  late MockAuthCubit authCubit;
  late MockThemeCubit themeCubit;
  late MockPaymentCubit paymentCubit;

  final menuTransactionsState = const MenuTransactionsWithAccountsSuccess(
    transactions: [],
    accounts: [],
    reasons: [],
    partners: [],
    partnerTypes: [],
    partnerBalances: {},
  );

  setUp(() {
    menuCubit = MockMenuCubit();
    credentialCubit = MockCredentialCubit();
    authCubit = MockAuthCubit();
    themeCubit = MockThemeCubit();
    paymentCubit = MockPaymentCubit();

    when(() => menuCubit.state).thenReturn(menuTransactionsState);
    when(() => credentialCubit.state).thenReturn(CredentialInitial());
    when(() => authCubit.state).thenReturn(AuthInitialState());
    when(() => themeCubit.state).thenReturn(ThemeMode.light);
    when(() => paymentCubit.state).thenReturn(const PaymentState());

    when(() => menuCubit.getTransactionsWithAccounts(force: any(named: 'force')))
        .thenAnswer((_) async {});
    when(() => menuCubit.getTransactionsWithAccounts()).thenAnswer((_) async {});
    when(() => menuCubit.getAccounts()).thenAnswer((_) async {});
    when(() => credentialCubit.getUserById()).thenReturn(null);
    when(() => credentialCubit.deleteUserById()).thenReturn(null);
    when(() => authCubit.logout()).thenReturn(null);
    when(() => themeCubit.toggleDark(any())).thenAnswer((_) async {});
    when(() => paymentCubit.load()).thenAnswer((_) async {});
    when(() => paymentCubit.fetchSubscriptions()).thenAnswer((_) async {});
  });

  testWidgets('HomePage widget smoke', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        child: const HomePage(),
        providers: [
          BlocProvider<MenuCubit>.value(value: menuCubit),
          BlocProvider<CredentialCubit>.value(value: credentialCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
      ),
    );
    await tester.pump();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('OperationPage widget smoke', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        child: const OperationPage(),
        providers: [
          BlocProvider<MenuCubit>.value(value: menuCubit),
          BlocProvider<CredentialCubit>.value(value: credentialCubit),
        ],
      ),
    );
    await tester.pump();
    expect(find.byType(OperationPage), findsOneWidget);
  });

  testWidgets('MenuPage widget smoke', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        child: const MenuPage(),
        providers: [
          BlocProvider<MenuCubit>.value(value: menuCubit),
          BlocProvider<CredentialCubit>.value(value: credentialCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
      ),
    );
    await tester.pump();
    expect(find.byType(MenuPage), findsOneWidget);
  });

  testWidgets('AccountPage widget smoke', (tester) async {
    when(() => menuCubit.state).thenReturn(const MenuAccountsSuccess(accounts: []));

    await tester.pumpWidget(
      _wrapWithApp(
        child: const AccountPage(),
        providers: [BlocProvider<MenuCubit>.value(value: menuCubit)],
      ),
    );
    await tester.pump();
    expect(find.byType(AccountPage), findsOneWidget);
  });

  testWidgets('PaymentPage widget smoke', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        child: const PaymentPage(),
        providers: [
          BlocProvider<PaymentCubit>.value(value: paymentCubit),
          BlocProvider<MenuCubit>.value(value: menuCubit),
        ],
      ),
    );
    await tester.pump();
    expect(find.byType(PaymentPage), findsOneWidget);
  });

  testWidgets('SettingsAppPage widget smoke', (tester) async {
    await tester.pumpWidget(
      _wrapWithApp(
        child: const SettingsAppPage(),
        providers: [BlocProvider<ThemeCubit>.value(value: themeCubit)],
      ),
    );
    await tester.pump();
    expect(find.byType(SettingsAppPage), findsOneWidget);
  });

  testWidgets('ProfilePage widget smoke', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(() => credentialCubit.state).thenReturn(
      const CredentialUserLoaded(
        user: AuthEntity(
          id: 1,
          username: 'test',
          password: 'secret',
          email: 'test@mail.com',
        ),
      ),
    );

    await tester.pumpWidget(
      _wrapWithApp(
        child: const ProfilePage(),
        providers: [
          BlocProvider<CredentialCubit>.value(value: credentialCubit),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
      ),
    );
    await tester.pump();
    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
