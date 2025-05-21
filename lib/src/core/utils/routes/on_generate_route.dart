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

      case AppRoutes.addAccount:
        return CupertinoPageRoute(builder: (_) => AddAccountPage());

      default:
        return errorRoute();
    }
  }

  static Route? errorRoute() =>
      CupertinoPageRoute(builder: (_) => const UnknownPage());
}
