import 'dart:async';
import 'package:flutter/material.dart';

class PassSuccessPage extends StatefulWidget {
  const PassSuccessPage({super.key});

  @override
  State<PassSuccessPage> createState() => _PassSuccessPageState();
}

class _PassSuccessPageState extends State<PassSuccessPage> {
  String email = "example@gmail.com"; // Replace with actual user email
  List<String> otpDigits = List.filled(4, '');
  late final List<FocusNode> focusNodes;

  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    // Resend OTP logic here
    _startCountdown();
  }

  String _maskEmail(String email) {
    int index = email.indexOf('@');
    if (index <= 2) return email;
    return '${email.substring(0, 2)}${'*' * (index - 2)}${email.substring(index)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200),

            // Centered Image
            Center(
              child: Image.asset(
                'assets/icons/success_check.png', // Make sure to add this image in pubspec.yaml
                width: 98,
                height: 98,
              ),
            ),

            SizedBox(height: 20),

            // Centered Text
            Center(
              child: Text(
                "Вы успешно изменили пароль!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 32),

            // Button with side padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/new-password');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF661EFB),
                    disabledBackgroundColor: Color(0xFFC7C8FF),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Вернуться на главную",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
