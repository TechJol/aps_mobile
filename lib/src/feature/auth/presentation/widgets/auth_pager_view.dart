import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class AuthPagerView extends StatelessWidget {
  const AuthPagerView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onPageChanged,
  });

  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F00C0),
      body: Column(
        children: [
          const SizedBox(height: 90),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                t.auth.welcome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AuthTabButton(
                          title: t.auth.login,
                          active: currentIndex == 0,
                          onTap: () => onTabSelected(0),
                          width: 100,
                        ),
                        const SizedBox(width: 15),
                        AuthTabButton(
                          title: t.auth.register,
                          active: currentIndex == 1,
                          onTap: () => onTabSelected(1),
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: controller,
                      onPageChanged: onPageChanged,
                      children: const [
                        LoginFormEmbedded(),
                        RegistrationFormEmbedded(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
