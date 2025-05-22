import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          nameController.text.isNotEmpty &&
          typeController.text.isNotEmpty &&
          currencyController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
    typeController.addListener(checkFormValidity);
    currencyController.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backroundColor,
        centerTitle: true,
        title: Text('Добавить счет', style: AppTextStyles.f24w600),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          30.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                TextFieldWithSuffix(
                  controller: nameController,
                  label: 'Название',
                ),
                12.h,
                TextFieldWithSuffix(controller: typeController, label: 'Тип'),
                12.h,
                TextFieldWithSuffix(
                  controller: currencyController,
                  label: 'Валюта',
                ),
                24.h,
                ElevatedButtonWidget(
                  text: 'Сохранить',
                  onPressed:
                      isFormValid
                          ? () {
                            // Save action
                          }
                          : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
