import 'package:flutter/material.dart';

import 'package:aps_mobile/src/feature/auth/presentation/widgets/auth_pager_view.dart';

class AuthPagerPage extends StatefulWidget {
  const AuthPagerPage({super.key});

  @override
  State<AuthPagerPage> createState() => _AuthPagerPageState();
}

class _AuthPagerPageState extends State<AuthPagerPage> {
  final PageController _controller = PageController();
  int _index = 0;

  void _go(int i) {
    if (_index == i) return;
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
    return AuthPagerView(
      controller: _controller,
      currentIndex: _index,
      onTabSelected: _go,
      onPageChanged: (i) => setState(() => _index = i),
    );
  }
}
