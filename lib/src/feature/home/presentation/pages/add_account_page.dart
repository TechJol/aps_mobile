import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final List<String> currencies = ['Доллар', 'Сом', 'Рубль', 'Евро'];
  final List<String> types = ['Банк', 'Касса'];
  final List<String> names = ['Бакай банк', 'Мбанк', 'Офис касса'];

  String? selectedName;
  String? selectedType;
  String? selectedCurrency;

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          selectedName != null &&
          selectedType != null &&
          selectedCurrency != null &&
          selectedName!.isNotEmpty &&
          selectedType!.isNotEmpty &&
          selectedCurrency!.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.backroundColor,
        centerTitle: true,
        title: Text('Редактировать счет', style: AppTextStyles.f24w600),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropDownFormField(
              items: names,
              label: 'Название',
              value: selectedName,
              onChanged: (val) {
                setState(() {
                  selectedName = val;
                });
                checkFormValidity();
              },
            ),
            const SizedBox(height: 12),
            DropDownFormField(
              items: types,
              label: 'Тип',
              value: selectedType,
              onChanged: (val) {
                setState(() {
                  selectedType = val;
                });
                checkFormValidity();
              },
            ),
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
                        // Сактоо логикасы
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
    );
  }
}
