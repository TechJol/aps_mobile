// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);

    usernameFocus.addListener(() {
      if (!usernameFocus.hasFocus) {
        setState(() => usernameTouched = true);
      }
    });
    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) {
        setState(() => passwordTouched = true);
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
                ? const Color(0xFF661EFB)
                : Colors.transparent,
      ),
    );
  }

  Future<void> _onLoginSuccessNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTag = prefs.getString('app_locale');

    // если язык уже выбран ранее — сразу в Main
    if (savedTag != null && savedTag.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
    } else {
      // иначе показываем выбор языка
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.languageSelection,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F00C0),
      body: BlocListener<CredentialCubit, CredentialState>(
        listener: (context, state) async {
          if (state is CredentialSuccess) {
            // После успешного логина синхронизируем глобальное состояние авторизации,
            // чтобы дальнейший Logout корректно отрабатывал.
            context.read<AuthCubit>().appStarted();
            await _onLoginSuccessNavigate();
          }
          if (state is CredentialFailure) {
            final snackBar = SnackBar(content: Text(state.errorMessage));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: _bodyWidget(context),
      ),
    );
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // приветствие можно тоже локализовать: t.auth.welcome
              // но оставляю как в твоём коде:
              // t.auth.welcome,
              // Если у тебя есть ключ, замени строку выше
              // а эту — убери
              // ↓
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            decoration: const BoxDecoration(
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
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Text(
                                t.auth.login,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (isLoginSelected || isLoginFormValid)
                                          ? const Color(0xFF661EFB)
                                          : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 100,
                                color:
                                    (isLoginSelected || isLoginFormValid)
                                        ? const Color(0xFF661EFB)
                                        : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () async {
                          setState(() => isLoginSelected = false);
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.registration,
                          );
                          setState(() => isLoginSelected = true);
                        },
                        child: Column(
                          children: [
                            Text(
                              t.auth.register,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    !isLoginSelected
                                        ? const Color(0xFF661EFB)
                                        : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                const SizedBox(height: 70),

                // Username
                TextField(
                  controller: usernameController,
                  focusNode: usernameFocus,
                  textInputAction: TextInputAction.next,
                  onSubmitted:
                      (_) => FocusScope.of(context).requestFocus(passwordFocus),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: t.auth.logIn,
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
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

                const SizedBox(height: 25),

                // Password
                TextField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    hintText: t.auth.password,
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed:
                          () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                BlocBuilder<CredentialCubit, CredentialState>(
                  builder: (context, state) {
                    if (state is CredentialLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed:
                          isFormValid
                              ? () {
                                final user = AuthEntity(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                );
                                context.read<CredentialCubit>().login(
                                  user.username,
                                  user.password,
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFormValid
                                ? const Color(0xFF661EFB)
                                : const Color(0xFFC7C8FF),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        t.auth.login,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
