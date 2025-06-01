import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class AddTypePage extends StatefulWidget {
  const AddTypePage({super.key});

  @override
  State<AddTypePage> createState() => _AddTypePageState();
}

class _AddTypePageState extends State<AddTypePage> {
  final nameController = TextEditingController();

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
  }

  @override
  void dispose() {
    nameController.removeListener(checkFormValidity);
    nameController.dispose();
    super.dispose();
  }

  void checkFormValidity() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Добавить тип',
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
