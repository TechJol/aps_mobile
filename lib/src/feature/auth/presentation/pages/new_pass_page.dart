import 'package:flutter/material.dart';

class NewPassPage extends StatefulWidget {
  const NewPassPage({super.key});

  @override
  _NewPassPageState createState() => _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
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
      isLoginFormValid =
          usernameController.text.trim().isNotEmpty &&
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
        color:
            touched && text.trim().isNotEmpty
                ? Color(0xFF661EFB)
                : Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F00C0),
      body: Column(
        children: [
          SizedBox(height: 65),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "Забыли пароль",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 105),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => isLoginSelected = true),
                          child: Container(
                            color:
                                Colors
                                    .transparent, // Prevents inherited background
                            child: Column(children: [SizedBox(height: 4)]),
                          ),
                        ),
                        SizedBox(width: 15),
                        // Регистрация
                        GestureDetector(
                          onTap: () async {
                            setState(() => isLoginSelected = false);
                            await Navigator.pushNamed(context, '/registration');
                            // When coming back from registration, reset the tab to login
                            setState(() => isLoginSelected = true);
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 120,
                                color:
                                    !isLoginSelected
                                        ? const Color(0xFF661EFB)
                                        : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),

                  // Username input
                  TextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted:
                        (_) =>
                            FocusScope.of(context).requestFocus(passwordFocus),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Введите новый пароль',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.visibility_off,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      border: _getBorder(
                        usernameTouched,
                        usernameController.text,
                      ),
                      enabledBorder: _getBorder(
                        usernameTouched,
                        usernameController.text,
                      ),
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Подтвердите пароль',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Icons.visibility_off,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      border: _getBorder(
                        passwordTouched,
                        passwordController.text,
                      ),
                      enabledBorder: _getBorder(
                        passwordTouched,
                        passwordController.text,
                      ),
                      focusedBorder: _getBorder(true, passwordController.text),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  SizedBox(height: 60),

                  // Login button
                  ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () {
                              Navigator.pushNamed(context, '/password-success');
                            }
                            : null, // Disables button if form is not valid
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFormValid
                              ? const Color(0xFF661EFB) // Normal purple
                              : const Color(
                                0xFFC7C8FF,
                              ), // Desaturated lighter purple for "disabled" look
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Сохранить",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
