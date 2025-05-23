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
  String? selectedName;
  String? selectedType;
  String? selectedCurrency;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          nameController.text.isNotEmpty &&
          typeController.text.isNotEmpty &&
          selectedCurrency != null &&
          selectedCurrency!.isNotEmpty;
      selectedType != null && selectedType!.isNotEmpty;
      selectedName != null && selectedName!.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
    typeController.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  final List<String> currencies = ['Доллар', 'Сом', 'Рубль', 'Евро'];

  final List<String> types = ['банк', 'касса'];

  final List<String> names = ['Бакай Банк', 'Мбанк', 'Офис касса'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
                DropdownFormField(
                  label: 'Название',
                  currencies: names,
                  value: selectedName,
                  onChanged: (value) {
                    setState(() {
                      selectedName = value;
                    });
                    checkFormValidity();
                  },
                ),
                12.h,
                DropdownFormField(
                  label: 'Тип',
                  currencies: types,
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                    checkFormValidity();
                  },
                ),
                12.h,
                // Вот поле с Dropdown
                DropdownFormField(
                  label: 'Валюта',
                  currencies: currencies,
                  value: selectedCurrency,
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value;
                    });
                    checkFormValidity();
                  },
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
