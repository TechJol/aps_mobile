import 'package:aps_mobile/HomePage.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'Registration.dart';
import 'LanguageSelection.dart';

void main() {
  runApp(AccountingApp());
}

class AccountingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Accounting App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/registration': (context) => Registration(),
        //'/forgot-password': (context) => ForgotPasswordPage(),
        '/language-selection': (context) => LanguageSelection(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
