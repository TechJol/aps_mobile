// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class NewPassPage extends StatefulWidget {
  const NewPassPage({super.key});

  @override
  _NewPassPageState createState() => _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  bool isFormValid = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode newPasswordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool newPasswordTouched = false;
  bool confirmPasswordTouched = false;

  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    newPasswordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);

    newPasswordFocus.addListener(() {
      if (!newPasswordFocus.hasFocus) {
        if (!newPasswordTouched) {
          setState(() {
            newPasswordTouched = true;
          });
        }
      }
    });

    confirmPasswordFocus.addListener(() {
      if (!confirmPasswordFocus.hasFocus) {
        if (!confirmPasswordTouched) {
          setState(() {
            confirmPasswordTouched = true;
          });
        }
      }
    });
  }

  void _validateForm() {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    final isValid =
        newPass.isNotEmpty && confirmPass.isNotEmpty && newPass == confirmPass;

    if (isFormValid != isValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocus.dispose();
    confirmPasswordFocus.dispose();
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

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool obscureText,
    required VoidCallback toggleObscure,
    required bool touched,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction:
          focusNode == confirmPasswordFocus
              ? TextInputAction.done
              : TextInputAction.next,
      onSubmitted: (_) {
        if (focusNode == newPasswordFocus) {
          FocusScope.of(context).requestFocus(confirmPasswordFocus);
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black.withOpacity(0.4),
          ),
          onPressed: toggleObscure,
        ),
        border: _getBorder(touched, controller.text),
        enabledBorder: _getBorder(touched, controller.text),
        focusedBorder: _getBorder(true, controller.text),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F00C0),
      body: Column(
        children: [
          const SizedBox(height: 65),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
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
          const SizedBox(height: 105),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  _buildPasswordField(
                    hint: 'Введите новый пароль',
                    controller: newPasswordController,
                    focusNode: newPasswordFocus,
                    obscureText: obscureNewPassword,
                    toggleObscure:
                        () => setState(
                          () => obscureNewPassword = !obscureNewPassword,
                        ),
                    touched: newPasswordTouched,
                  ),
                  const SizedBox(height: 25),
                  _buildPasswordField(
                    hint: 'Подтвердите пароль',
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocus,
                    obscureText: obscureConfirmPassword,
                    toggleObscure:
                        () => setState(
                          () =>
                              obscureConfirmPassword = !obscureConfirmPassword,
                        ),
                    touched: confirmPasswordTouched,
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () => Navigator.pushNamed(
                              context,
                              AppRoutes.passwordSuccess,
                            )
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
                    child: const Text(
                      "Сохранить",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!isFormValid &&
                      (newPasswordTouched || confirmPasswordTouched))
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        newPasswordController.text !=
                                confirmPasswordController.text
                            ? "Пароли не совпадают"
                            : "Пожалуйста, заполните все поля",
                        style: const TextStyle(color: Colors.red),
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
