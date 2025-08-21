import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'src/feature/feature.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await di.init();

  runApp(TranslationProvider(child: MyApp()));
  // runApp(MyApp());
}
