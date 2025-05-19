import 'package:aps_mobile/src/feature/auth/presentation/pages/forgot_pass_page.dart';
import 'package:aps_mobile/src/feature/auth/presentation/pages/language_page.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
//import 'package:aps_mobile/HomePage.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'src/feature/auth/presentation/pages/login_page.dart';
import 'src/feature/auth/presentation/pages/registration_page.dart';
import 'HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const AccountingApp());
}

class AccountingApp extends StatelessWidget {
  const AccountingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Accounting App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/registration': (context) => Registration(),
        '/forgot-password': (context) => ForgotPassPage(),
        '/language-selection': (context) => LanguageSelection(),
        //'/home': (context) => HomePage(),
      },
    );
  }
}
