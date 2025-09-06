import 'package:flutter/widgets.dart';
import 'package:aps_mobile/src/core/core.dart'; // AppRoutes

class AppNavigator {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static Future<void> toLogin() async {
    final nav = key.currentState;
    if (nav == null) return;
    nav.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    ); // '/' у тебя
  }
}
