import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final List<String> currencies = ['Доллар', 'Сом', 'Рубль', 'Евро'];
  final List<String> types = ['Банк', 'Касса'];
  final List<String> names = ['Бакай банк', 'Мбанк', 'Офис касса'];

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

                const SizedBox(height: 12),
                TextFieldWid(label: 'Тип', controller: typeController),
                const SizedBox(height: 12),
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

                const SizedBox(height: 24),

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
