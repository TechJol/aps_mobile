// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/core/utils/reg_exp/app_reg_exp.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationFormEmbedded extends StatefulWidget {
  const RegistrationFormEmbedded({super.key});

  @override
  State<RegistrationFormEmbedded> createState() =>
      _RegistrationFormEmbeddedState();
}

class _RegistrationFormEmbeddedState extends State<RegistrationFormEmbedded> {
  final TextEditingController firmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isFormValid = false;
  bool isAgreementChecked = false;
  bool _obscureRegPassword = true;

  String? companyError;
  String? usernameError;
  String? emailError;
  String? nameError;
  String? surnameError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    for (final c in [
      firmController,
      usernameController,
      emailController,
      nameController,
      surnameController,
      passwordController,
    ]) {
      c.addListener(_validateForm);
    }
  }

  @override
  void dispose() {
    for (final c in [
      firmController,
      usernameController,
      emailController,
      nameController,
      surnameController,
      passwordController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _validateForm() {
    final company = firmController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final firstName = nameController.text.trim();
    final lastName = surnameController.text.trim();
    final password = passwordController.text.trim();

    String? localCompanyError;
    String? localUsernameError;
    String? localEmailError;
    String? localNameError;
    String? localSurnameError;
    String? localPasswordError;

    // Only show errors for non-empty invalid fields
    if (company.isNotEmpty && !AppRegExp.companyName.hasMatch(company)) {
      localCompanyError = t.auth.validation.companyInvalid;
    }
    if (username.isNotEmpty && !AppRegExp.username.hasMatch(username)) {
      localUsernameError = t.auth.validation.usernameInvalid;
    }
    if (email.isNotEmpty && !AppRegExp.email.hasMatch(email)) {
      localEmailError = t.auth.validation.emailInvalid;
    }
    if (firstName.isNotEmpty && !AppRegExp.personName.hasMatch(firstName)) {
      localNameError = t.auth.validation.nameInvalid;
    }
    if (lastName.isNotEmpty && !AppRegExp.personName.hasMatch(lastName)) {
      localSurnameError = t.auth.validation.surnameInvalid;
    }
    if (password.isNotEmpty && !AppRegExp.password.hasMatch(password)) {
      localPasswordError = t.auth.validation.passwordInvalid;
    }

    final allNonEmpty =
        company.isNotEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        password.isNotEmpty;

    final allValid =
        (localCompanyError == null) &&
        (localUsernameError == null) &&
        (localEmailError == null) &&
        (localNameError == null) &&
        (localSurnameError == null) &&
        (localPasswordError == null);

    setState(() {
      companyError = localCompanyError;
      usernameError = localUsernameError;
      emailError = localEmailError;
      nameError = localNameError;
      surnameError = localSurnameError;
      passwordError = localPasswordError;

      isFormValid = allNonEmpty && allValid && isAgreementChecked;
    });
  }

  OutlineInputBorder _getBorder(bool hasText, {bool isError = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide:
          isError
              ? const BorderSide(color: Colors.red, width: 1.5)
              : hasText
              ? const BorderSide(color: Color(0xFF661EFB), width: 1.5)
              : BorderSide.none,
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    String? errorText,
  }) {
    final hasText = controller.text.trim().isNotEmpty;
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureRegPassword : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
        border: _getBorder(hasText, isError: errorText != null),
        enabledBorder: _getBorder(hasText, isError: errorText != null),
        focusedBorder: _getBorder(hasText, isError: errorText != null),
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey.shade50,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscureRegPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed:
                      () => setState(
                        () => _obscureRegPassword = !_obscureRegPassword,
                      ),
                )
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CredentialCubit, CredentialState>(
      listener: (context, state) {
        if (state is CredentialSuccess) {
          setState(() {
            companyError = null;
            usernameError = null;
            emailError = null;
          });
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (route) => false,
          );
        }
        if (state is CredentialFailure) {
          setState(() {
            companyError = null;
            usernameError = null;
            emailError = null;

            switch (state.errorCode) {
              case AuthErrorCodes.companyExists:
                companyError = state.errorMessage;
                break;
              case AuthErrorCodes.emailExists:
                emailError = state.errorMessage;
                break;
              case AuthErrorCodes.usernameExists:
                usernameError = state.errorMessage;
                break;
              default:
                break;
            }
          });

          final handledCodes = <String>{
            AuthErrorCodes.companyExists,
            AuthErrorCodes.emailExists,
            AuthErrorCodes.usernameExists,
          };

          if (!handledCodes.contains(state.errorCode)) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildField(
                controller: firmController,
                hint: t.auth.company,
                errorText: companyError,
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: usernameController,
                hint: t.auth.username,
                errorText: usernameError,
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: emailController,
                hint: t.auth.email,
                errorText: emailError,
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: nameController,
                hint: t.auth.name,
                errorText: nameError,
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: surnameController,
                hint: t.auth.surname,
                errorText: surnameError,
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: passwordController,
                hint: t.auth.password,
                isPassword: true,
                errorText: passwordError,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isAgreementChecked,
                      onChanged: (v) {
                        setState(() {
                          isAgreementChecked = v ?? false;
                          _validateForm();
                        });
                      },
                      activeColor: const Color(0xFF661EFB),
                      checkColor: Colors.white,
                      fillColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFF661EFB);
                        }
                        return Colors.white;
                      }),
                      side: WidgetStateBorderSide.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return const BorderSide(
                            color: Color(0xFF661EFB),
                            width: 2,
                          );
                        }
                        return const BorderSide(color: Colors.grey, width: 2);
                      }),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      t.auth.agreement,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF661EFB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              BlocBuilder<CredentialCubit, CredentialState>(
                builder: (context, state) {
                  if (state is CredentialLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () {
                              final user = AuthModel(
                                username: usernameController.text,
                                password: passwordController.text,
                                email: emailController.text,
                                firstName: nameController.text,
                                lastName: surnameController.text,
                                companyName: firmController.text,
                              );
                              context.read<CredentialCubit>().register(user);
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
                      t.auth.registerButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
