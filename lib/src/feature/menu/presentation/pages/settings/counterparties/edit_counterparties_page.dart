import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class EditCounterpartiesPage extends StatefulWidget {
  const EditCounterpartiesPage({super.key});

  @override
  State<EditCounterpartiesPage> createState() => _EditCounterpartiesPageState();
}

class _EditCounterpartiesPageState extends State<EditCounterpartiesPage> {
  final List<String> types = ['Клиент', 'Сотрудник', 'Поставщик'];

  final nameController = TextEditingController();
  final contactInfoController = TextEditingController();

  String? selectedType;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    // Подписываемся на изменения текста
    nameController.addListener(checkFormValidity);
    contactInfoController.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    nameController.removeListener(checkFormValidity);
    contactInfoController.removeListener(checkFormValidity);
    nameController.dispose();
    contactInfoController.dispose();
    super.dispose();
  }

  void checkFormValidity() {
    setState(() {
      isFormValid =
          selectedType != null &&
          selectedType!.isNotEmpty &&
          nameController.text.isNotEmpty &&
          contactInfoController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Редактировать контрагента',
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
                12.h,
                TextFieldWid(
                  label: 'Контактная информация',
                  controller: contactInfoController,
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
