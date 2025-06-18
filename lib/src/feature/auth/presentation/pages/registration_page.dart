// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registration extends StatefulWidget {
  final void Function(int pageIndex)? onNavigate;
  const Registration({super.key, this.onNavigate});

  //const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool isLoginSelected = true;
  bool isFormValid = false;
  bool isAgreementChecked = false;

  final TextEditingController firmController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firmController.addListener(_validateForm);
    usernameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    nameController.addListener(_validateForm);
    surnameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isFormValid =
          firmController.text.trim().isNotEmpty &&
          usernameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          nameController.text.trim().isNotEmpty &&
          surnameController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          isAgreementChecked;
    });
  }

  @override
  void dispose() {
    firmController.dispose();
    usernameController.dispose();
    emailController.dispose();
    nameController.dispose();
    surnameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  OutlineInputBorder getDynamicBorder(bool hasText) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide:
          hasText
              ? BorderSide(color: Color(0xFF661EFB), width: 1.5)
              : BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F00C0),
      body: BlocListener<CredentialCubit, CredentialState>(
        listener: (context, state) {
          if (state is CredentialSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.main,
              (route) => false,
            );
          }
          if (state is CredentialFailure) {
            var snackBar = SnackBar(content: Text(state.errorMessage));
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Toggle between Login/Register
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Войти tab
                        GestureDetector(
                          onTap: () {
                            widget.onNavigate?.call(0); // Go back to LoginPage
                          },
                          child: Column(
                            children: [
                              Text(
                                "Войти",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 100,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 15),

                        // Регистрация tab
                        GestureDetector(
                          onTap: () {
                            print("Navigating to page 1");
                            widget.onNavigate?.call(1);
                          }, // Already here
                          child: Column(
                            children: [
                              Text(
                                "Регистрация",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF661EFB),
                                  //decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 120,
                                color: Color(0xFF661EFB),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Input fields
                  buildInputField(controller: firmController, hint: "Фирма"),
                  SizedBox(height: 24),
                  buildInputField(
                    controller: usernameController,
                    hint: "Пользовательское имя",
                  ),
                  SizedBox(height: 24),
                  buildInputField(
                    controller: emailController,
                    hint: "Эл.адрес",
                  ),
                  SizedBox(height: 24),
                  buildInputField(controller: nameController, hint: "Имя"),
                  SizedBox(height: 24),
                  buildInputField(
                    controller: surnameController,
                    hint: "Фамилия",
                  ),
                  SizedBox(height: 24),
                  buildInputField(
                    controller: passwordController,
                    hint: "Придумайте пароль",
                  ),
                  SizedBox(height: 15),

                  // Checkbox for agreement
                  Row(
                    children: [
                      Transform.scale(
                        scale: 0.8, // Adjust to control size
                        child: Checkbox(
                          value: isAgreementChecked,
                          onChanged: (value) {
                            setState(() {
                              isAgreementChecked = value ?? false;
                              _validateForm(); // Re-validate form
                            });
                          },
                          activeColor: Color(
                            0xFF661EFB,
                          ), // Purple fill when checked
                          checkColor: Colors.white,
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Color(0xFF661EFB); // Purple when checked
                            }
                            return Colors.white; // White fill when unchecked
                          }),
                          side: WidgetStateBorderSide.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return BorderSide(
                                color: Color(0xFF661EFB),
                                width: 2,
                              );
                            }
                            return BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ); // Grey border when unchecked
                          }),
                          visualDensity:
                              VisualDensity.compact, // Tighter spacing
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Принимаю все условии пользовательского соглашения",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF661EFB),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),

                  // Login button
                  BlocBuilder<CredentialCubit, CredentialState>(
                    builder: (context, state) {
                      if (state is CredentialLoading) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   AppRoutes.languageSelection,
                                  // );

                                  final user = AuthModel(
                                    username: usernameController.text,
                                    password: passwordController.text,
                                    email: emailController.text,
                                    firstName: nameController.text,
                                    lastName: surnameController.text,
                                    companyName: firmController.text,
                                  );

                                  context.read<CredentialCubit>().register(
                                    user,
                                  );
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
                          "Зарегистрироваться",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    final hasText = controller.text.trim().isNotEmpty;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
        border: getDynamicBorder(hasText),
        enabledBorder: getDynamicBorder(hasText),
        focusedBorder: getDynamicBorder(hasText),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
