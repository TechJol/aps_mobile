import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}
