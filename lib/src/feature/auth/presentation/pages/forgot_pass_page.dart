import 'dart:async';
import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  String email = "example@gmail.com";
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
    _startCountdown();
  }

  String _maskEmail(String email) {
    int index = email.indexOf('@');
    if (index <= 2) return email;
    String visiblePart = email.substring(index - 2, index);
    return '${'*' * (index - 2)}$visiblePart${email.substring(index)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 55),
            Text(
              "Мы отправили код в вашу эл. почту",
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey.shade600,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              _maskEmail(email),
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.6),
                  child: SizedBox(
                    width: 76,
                    height: 42,
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
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color:
                                otpDigits[index].isNotEmpty
                                    ? Color(0xFF661EFB)
                                    : Colors.grey.shade300,
                            width: otpDigits[index].isNotEmpty ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xFF661EFB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: _canResend ? _resendCode : null,
                child: Text(
                  _canResend
                      ? "Отправить код повторно"
                      : "Отправить повторно через: $_secondsRemaining",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: _canResend ? Color(0xFF661EFB) : Color(0xFF7B818C),
                    decoration: _canResend ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),

            SizedBox(height: 425),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    otpDigits.every((d) => d.isNotEmpty)
                        ? () =>
                            Navigator.pushNamed(context, AppRoutes.newPassword)
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
