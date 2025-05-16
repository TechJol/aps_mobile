import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginSelected = true;
  bool isFormValid = false;
  bool isLoginFormValid = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool usernameTouched = false;
  bool passwordTouched = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);

    usernameFocus.addListener(() {
      if (!usernameFocus.hasFocus) {
        setState(() {
          usernameTouched = true;
        });
      }
    });

    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) {
        setState(() {
          passwordTouched = true;
        });
      }
    });
  }

  void _validateForm() {
    setState(() {
      isLoginFormValid = usernameController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
      isFormValid = isLoginSelected ? isLoginFormValid : false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  OutlineInputBorder _getBorder(bool touched, String text) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: touched && text.trim().isNotEmpty
            ? Color(0xFF661EFB)
            : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F00C0),
      body: Column(
        children: [
          SizedBox(height: 90),
          const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Привет!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Добро пожаловать",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Войти
                        GestureDetector(
                          onTap: () => setState(() => isLoginSelected = true),
                          child: Column(
                            children: [
                              Text(
                                "Войти",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isLoginSelected || isLoginFormValid
                                      ? const Color(0xFF661EFB)
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 100,
                                color: isLoginSelected || isLoginFormValid
                                    ? const Color(0xFF661EFB)
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        // Регистрация
                        GestureDetector(
                          onTap: () {
                            setState(() => isLoginSelected = false);
                            Navigator.pushNamed(context, '/registration');
                          },
                          child: Column(
                            children: [
                              Text(
                                "Регистрация",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isLoginSelected
                                      ? const Color(0xFF661EFB)
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 120,
                                color: !isLoginSelected
                                    ? const Color(0xFF661EFB)
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70),

                  // Username input
                  TextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(passwordFocus),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      hintText: 'Логин',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      border:
                          _getBorder(usernameTouched, usernameController.text),
                      enabledBorder:
                          _getBorder(usernameTouched, usernameController.text),
                      focusedBorder: _getBorder(true, usernameController.text),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  SizedBox(height: 25),

                  // Password input
                  TextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      hintText: 'Пароль',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      border:
                          _getBorder(passwordTouched, passwordController.text),
                      enabledBorder:
                          _getBorder(passwordTouched, passwordController.text),
                      focusedBorder: _getBorder(true, passwordController.text),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(left: 150.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          "Забыли пароль?",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF661EFB),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),

                  // Login button
                  Opacity(
                    opacity: isFormValid ? 1.0 : 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isFormValid) {
                          Navigator.pushNamed(context, '/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF661EFB),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Войти",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
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
