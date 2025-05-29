// // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

// import 'package:aps_mobile/src/core/core.dart';
// import 'package:flutter/material.dart';

// class Registration extends StatefulWidget {
//   const Registration({super.key});

//   @override
//   _RegistrationState createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {
//   bool isLoginSelected = true;
//   bool isFormValid = false;
//   bool isAgreementChecked = false;

//   final TextEditingController firmController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController surnameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     firmController.addListener(_validateForm);
//     usernameController.addListener(_validateForm);
//     emailController.addListener(_validateForm);
//     nameController.addListener(_validateForm);
//     surnameController.addListener(_validateForm);
//   }

//   void _validateForm() {
//     setState(() {
//       isFormValid =
//           firmController.text.trim().isNotEmpty &&
//           usernameController.text.trim().isNotEmpty &&
//           emailController.text.trim().isNotEmpty &&
//           nameController.text.trim().isNotEmpty &&
//           surnameController.text.trim().isNotEmpty &&
//           isAgreementChecked;
//     });
//   }

//   @override
//   void dispose() {
//     firmController.dispose();
//     usernameController.dispose();
//     emailController.dispose();
//     nameController.dispose();
//     surnameController.dispose();
//     super.dispose();
//   }

//   OutlineInputBorder getDynamicBorder(bool hasText) {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(30),
//       borderSide:
//           hasText
//               ? BorderSide(color: Color(0xFF661EFB), width: 1.5)
//               : BorderSide.none,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF3F00C0),
//       body: Column(
//         children: [
//           SizedBox(height: 90),
//           const Padding(
//             padding: EdgeInsets.only(left: 30.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Привет!",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.only(left: 30.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Добро пожаловать",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 50),
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 20.0,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Toggle between Login/Register
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // Войти tab
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pop(
//                                 context,
//                                 AppRoutes.login,
//                               ); // Go back to LoginPage
//                             },
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "Войти",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Container(
//                                   height: 2,
//                                   width: 100,
//                                   color: Colors.transparent,
//                                 ),
//                               ],
//                             ),
//                           ),

//                           SizedBox(width: 15),

//                           // Регистрация tab
//                           GestureDetector(
//                             onTap: () {}, // Already here
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "Регистрация",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF661EFB),
//                                     //decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Container(
//                                   height: 2,
//                                   width: 120,
//                                   color: Color(0xFF661EFB),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: 30),

//                     // Input fields
//                     buildInputField(controller: firmController, hint: "Фирма"),
//                     SizedBox(height: 20),
//                     buildInputField(
//                       controller: usernameController,
//                       hint: "Пользовательское имя",
//                     ),
//                     SizedBox(height: 20),
//                     buildInputField(
//                       controller: emailController,
//                       hint: "Эл.адрес",
//                     ),
//                     SizedBox(height: 20),
//                     buildInputField(controller: nameController, hint: "Имя"),
//                     SizedBox(height: 20),
//                     buildInputField(
//                       controller: surnameController,
//                       hint: "Фамилия",
//                     ),
//                     SizedBox(height: 20),

//                     // Checkbox for agreement
//                     Row(
//                       children: [
//                         Transform.scale(
//                           scale:
//                               0.8, // You can adjust this value (e.g., 0.7, 0.6) to make it smaller
//                           child: Checkbox(
//                             value: isAgreementChecked,
//                             onChanged: (value) {
//                               setState(() {
//                                 isAgreementChecked = value ?? false;
//                                 _validateForm(); // Re-validate form
//                               });
//                             },
//                             activeColor: Color(0xFF661EFB),
//                             //inactiveColor: Colors.grey,
//                             visualDensity:
//                                 VisualDensity.compact, // Makes spacing tighter
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             "Принимаю все условии пользовательского соглашения",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Color(0xFF661EFB),
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: 10),

//                     // Login button
//                     Opacity(
//                       opacity: isFormValid ? 1.0 : 0.2,
//                       child: ElevatedButton(
//                         onPressed:
//                             isFormValid
//                                 ? () {
//                                   Navigator.pushNamed(
//                                     context,
//                                     AppRoutes.languageSelection,
//                                   );
//                                 }
//                                 : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF661EFB),
//                           minimumSize: Size(double.infinity, 50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: Text(
//                           "Войти",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildInputField({
//     required TextEditingController controller,
//     required String hint,
//   }) {
//     final hasText = controller.text.trim().isNotEmpty;
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
//         border: getDynamicBorder(hasText),
//         enabledBorder: getDynamicBorder(hasText),
//         focusedBorder: getDynamicBorder(hasText),
//         filled: true,
//         fillColor: Colors.grey.shade50,
//       ),
//     );
//   }
