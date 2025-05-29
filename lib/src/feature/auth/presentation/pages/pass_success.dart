import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class PassSuccessPage extends StatefulWidget {
  const PassSuccessPage({super.key});

  @override
  State<PassSuccessPage> createState() => _PassSuccessPageState();
}

class _PassSuccessPageState extends State<PassSuccessPage> {
  String email = "example@gmail.com";

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
            Center(
              child: Text(
                "Вы успешно изменили пароль!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Masked email confirmation text
            Text(
              'На почту ${_maskEmail(email)} отправлено подтверждение',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                color: Colors.grey[600],
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
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF661EFB),
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
