import 'package:shared_preferences/shared_preferences.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'src/feature/feature.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  final prefs = await SharedPreferences.getInstance();
  final savedTag = prefs.getString('app_locale');
  if (savedTag != null) {
    final maybe = AppLocaleUtils.parse(savedTag);
    LocaleSettings.setLocale(maybe);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(TranslationProvider(child: const MyApp()));
}
