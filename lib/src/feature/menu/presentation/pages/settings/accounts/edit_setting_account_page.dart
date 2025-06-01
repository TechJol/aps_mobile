import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class EditSettingAccountPage extends StatefulWidget {
  const EditSettingAccountPage({super.key});

  @override
  State<EditSettingAccountPage> createState() => _EditSettingAccountPageState();
}

class _EditSettingAccountPageState extends State<EditSettingAccountPage> {
  final List<String> currencies = ['Доллар', 'Сом', 'Рубль', 'Евро'];

  final nameController = TextEditingController();
  final typeController = TextEditingController();

  String? selectedCurrency;

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          selectedCurrency != null &&
          selectedCurrency!.isNotEmpty &&
          nameController.text.isNotEmpty &&
          typeController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Редактировать счет',
        backgroundColor: AppColors.backroundColor,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.backroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
          24.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextFieldWid(label: 'Название', controller: nameController),

                12.h,
                TextFieldWid(label: 'Тип', controller: typeController),
                12.h,
                DropDownFormField(
                  items: currencies,
                  label: 'Валюта',
                  value: selectedCurrency,
                  onChanged: (val) {
                    setState(() {
                      selectedCurrency = val;
                    });
                    checkFormValidity();
                  },
                ),

                24.h,

                ElevatedButton(
                  onPressed:
                      isFormValid
                          ? () {
                            Navigator.pop(context);
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary200Color,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Сохранить',
                    style: AppTextStyles.f16w500.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
