import 'dart:async';
import 'package:flutter/material.dart';

class PassSuccessPage extends StatefulWidget {
  const PassSuccessPage({super.key});

  @override
  State<PassSuccessPage> createState() => _PassSuccessPageState();
}

class _PassSuccessPageState extends State<PassSuccessPage> {
  String email = "example@gmail.com"; // TODO: Replace with actual user email
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    // TODO: Add actual resend OTP logic here
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
            const SizedBox(height: 200),

            // Centered Success Image
            Center(
              child: Image.asset(
                'assets/icons/success_check.png', // Ensure this asset is declared in pubspec.yaml
                width: 98,
                height: 98,
              ),
            ),

            const SizedBox(height: 20),

            // Success message text
            const Center(
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

            const SizedBox(height: 32),

            // Button with horizontal padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to home page after password reset success
                    Navigator.pushNamed(context, '/home');
                    // Or to new password page if needed:
                    // Navigator.pushNamed(context, '/new-password');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF661EFB),
                    disabledBackgroundColor: const Color(0xFFC7C8FF),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Вернуться на главную",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
