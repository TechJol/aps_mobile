import 'package:flutter/material.dart';
import 'login.dart';
import 'registration_page.dart';
import 'forgot_pass_page.dart';

class AuthPageView extends StatefulWidget {
  const AuthPageView({super.key});

  @override
  State<AuthPageView> createState() => _AuthPageViewState();
}

class _AuthPageViewState extends State<AuthPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void navigateTo(int pageIndex) {
    print('Attempting to navigate to page $pageIndex');
    print('Has clients: ${_pageController.hasClients}');
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      print('Navigation triggered');
    } else {
      print('PageController has no clients yet.');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        //physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          print("Current Page Index: $index");
        },
        children: [
          LoginPage(onNavigate: navigateTo),
          Registration(onNavigate: navigateTo),
          ForgotPassPage(onNavigate: navigateTo),
        ],
      ),
      // Add the floatingActionButton here
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => navigateTo(1),
        tooltip: 'Go to Registration', // Navigate to Registration page (index 1)
        child: const Icon(Icons.navigate_next),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
