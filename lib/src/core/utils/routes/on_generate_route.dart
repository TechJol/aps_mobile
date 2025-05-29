import 'package:aps_mobile/pie_chart_page.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/cupertino.dart';
import 'app_routes.dart';
import 'unknown_page.dart';

class RouteGenerator {
  static Route? onGenerate(RouteSettings settings) {
    final route = settings.name;
    // final Object? arguments = settings.arguments;
    // final args = (arguments is Map<String, dynamic>) ? arguments : {};

    switch (route) {
      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => LoginPage());

      case AppRoutes.registration:
        return CupertinoPageRoute(builder: (_) => Registration());

      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => ForgotPassPage());

      case AppRoutes.languageSelection:
        return CupertinoPageRoute(builder: (_) => LanguageSelection());

      case AppRoutes.newPassword:
        return CupertinoPageRoute(builder: (_) => NewPassPage());

      case AppRoutes.passwordSuccess:
        return CupertinoPageRoute(builder: (_) => PassSuccessPage());

      case AppRoutes.pieChart:
        return CupertinoPageRoute(builder: (_) => PieChartPage());

      case AppRoutes.main:
        return CupertinoPageRoute(builder: (_) => MainView());

      case AppRoutes.home:
        return CupertinoPageRoute(builder: (_) => HomePage());

      case AppRoutes.account:
        return CupertinoPageRoute(builder: (_) => AccountPage());

      case AppRoutes.addAccount:
        return CupertinoPageRoute(builder: (_) => AddAccountPage());

      case AppRoutes.editAccount:
        return CupertinoPageRoute(builder: (_) => EditAccountPage());

      case AppRoutes.menu:
        return CupertinoPageRoute(builder: (_) => MenuPage());

      case AppRoutes.transactions:
        return CupertinoPageRoute(builder: (_) => TransactionsPage());

      case AppRoutes.counterparties:
        return CupertinoPageRoute(builder: (_) => CounterpartiesPage());

      case AppRoutes.menuAccounts:
        return CupertinoPageRoute(builder: (_) => MenuAccountsPage());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
