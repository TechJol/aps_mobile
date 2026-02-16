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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: scheme.onSurface,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8, height: 20),
                Text(
                  "Забыли пароль",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),

            55.h,
            Text(
              "Мы отправили код в вашу эл. почту",
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              _maskEmail(email),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),

            10.h,

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
                            color: otpDigits[index].isNotEmpty
                                ? AppColors.primary200Color
                                : scheme.outlineVariant,
                            width: otpDigits[index].isNotEmpty ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.primary200Color,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            20.h,

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
                    color: _canResend
                        ? AppColors.primary200Color
                        : scheme.onSurfaceVariant,
                    decoration: _canResend ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),

            425.h,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: otpDigits.every((d) => d.isNotEmpty)
                    ? () => Navigator.pushNamed(context, AppRoutes.newPassword)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary200Color,
                  disabledBackgroundColor: AppColors.primary50Color,
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
