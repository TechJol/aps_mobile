import 'dart:async';
import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar Row with Back Arrow
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8, height: 20),
                Text(
                  "Забыли пароль",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            Text(
              "Мы отправили код в вашу эл.почту",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              _maskEmail(email),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            SizedBox(height: 30),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 80,
                  child: TextField(
                    focusNode: focusNodes[index],
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(
                          context,
                        ).requestFocus(focusNodes[index + 1]);
                      }
                      setState(() => otpDigits[index] = value);
                    },
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF661EFB),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // Resend Code Text
            Center(
              child: GestureDetector(
                onTap: _canResend ? _resendCode : null,
                child: Text(
                  _canResend
                      ? "Отправить код повторно"
                      : "Отправить повторно через: $_secondsRemaining",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _canResend ? Color(0xFF661EFB) : Colors.grey,
                    decoration: _canResend ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),

            Spacer(),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    otpDigits.every((d) => d.isNotEmpty)
                        ? () => Navigator.pushNamed(context, '/home')
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF661EFB),
                  disabledBackgroundColor: Color(0xFFC7C8FF),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Далее",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
