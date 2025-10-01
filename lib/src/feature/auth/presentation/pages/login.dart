// ignore_for_file: file_names, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormEmbedded extends StatefulWidget {
  const LoginFormEmbedded({super.key});

  @override
  State<LoginFormEmbedded> createState() => _LoginFormEmbeddedState();
}

class _LoginFormEmbeddedState extends State<LoginFormEmbedded> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool usernameTouched = false;
  bool passwordTouched = false;
  bool _obscurePassword = true;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    usernameFocus.addListener(() {
      if (!usernameFocus.hasFocus) setState(() => usernameTouched = true);
    });
    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) setState(() => passwordTouched = true);
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

  void _validateForm() {
    setState(() {
      isFormValid =
          usernameController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
    });
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
    if (!mounted) return;
    final savedTag = prefs.getString('app_locale');
    if (savedTag != null && savedTag.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.languageSelection,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CredentialCubit, CredentialState>(
      listener: (context, state) async {
        if (state is CredentialSuccess) {
          final menuCubit = context.read<MenuCubit>()..reset();
          context.read<IncomeCubit>().clearAll();
          context.read<MainCubit>().reset();
          context.read<AuthCubit>().appStarted();
          await menuCubit.getTransactionsWithAccounts(force: true);
          if (!mounted) return;
          await _onLoginSuccessNavigate();
        }
        if (state is CredentialFailure) {
          final snackBar = SnackBar(content: Text(state.errorMessage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),

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
                border: _getBorder(usernameTouched, usernameController.text),
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
                border: _getBorder(passwordTouched, passwordController.text),
                enabledBorder: _getBorder(
                  passwordTouched,
                  passwordController.text,
                ),
                focusedBorder: _getBorder(true, passwordController.text),
                filled: true,
                fillColor: Colors.grey.shade50,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                            context.read<CredentialCubit>().login(
                              usernameController.text,
                              passwordController.text,
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
    );
  }
}
