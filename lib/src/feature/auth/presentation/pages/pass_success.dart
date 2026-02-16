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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),

            Center(
              child: Image.asset(
                'assets/icons/success_check.png',
                width: 98,
                height: 98,
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Вы успешно изменили пароль!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'На почту ${_maskEmail(email)} отправлено подтверждение',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: scheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary200Color,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Вернуться на главную",
                    style: TextStyle(
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
