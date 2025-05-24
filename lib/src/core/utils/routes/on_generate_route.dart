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

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
