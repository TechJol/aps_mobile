import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/feature/auth/presentation/pages/login.dart';
import 'package:aps_mobile/src/feature/auth/presentation/pages/registration_page.dart';
import 'package:flutter/material.dart';

class AuthPagerPage extends StatefulWidget {
  const AuthPagerPage({super.key});

  @override
  State<AuthPagerPage> createState() => _AuthPagerPageState();
}

class _AuthPagerPageState extends State<AuthPagerPage> {
  final PageController _controller = PageController();
  int _index = 0;

  void _go(int i) {
    setState(() => _index = i);
    _controller.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

          // Карточка с табами и страницами
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
                        _TabButton(
                          title: t.auth.login,
                          active: _index == 0,
                          onTap: () => _go(0),
                          width: 100,
                        ),
                        const SizedBox(width: 15),
                        _TabButton(
                          title: t.auth.register,
                          active: _index == 1,
                          onTap: () => _go(1),
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (i) => setState(() => _index = i),
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

class _TabButton extends StatelessWidget {
  final String title;
  final bool active;
  final double width;
  final VoidCallback onTap;
  const _TabButton({
    required this.title,
    required this.active,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF661EFB) : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: width,
            color: active ? const Color(0xFF661EFB) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

