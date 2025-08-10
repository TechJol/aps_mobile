import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditArticlesPage extends StatefulWidget {
  const EditArticlesPage({super.key, required this.reason});
  final IncomeExpenseReasons reason;

  @override
  State<EditArticlesPage> createState() => _EditArticlesPageState();
}

class _EditArticlesPageState extends State<EditArticlesPage> {
  final nameController = TextEditingController();

  // String? selectedName;
  String? selectedType;
  bool isFormValid = false;

  final typeToLabel = {'income': 'Доход', 'expense': 'Расход'};

  final labelToType = {'Доход': 'income', 'Расход': 'expense'};

  void checkFormValidity() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty && selectedType != null;
    });
  }

  @override
  void initState() {
    // selectedName = widget.reason.name;
    nameController.text = widget.reason.name;

    selectedType = typeToLabel[widget.reason.type];

    nameController.addListener(checkFormValidity);

    checkFormValidity();
    super.initState();
  }

  @override
  void dispose() {
    nameController.removeListener(checkFormValidity);
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Редактировать статью',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuReasonsSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  24.h,
                  TextFieldWid(label: 'Название', controller: nameController),

                  const SizedBox(height: 12),
                  DropDownFormField(
                    items: typeToLabel.values.toList(),
                    label: 'Тип',
                    value: selectedType,
                    onChanged: (val) {
                      setState(() => selectedType = val);
                      checkFormValidity();
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () {
                              final id = widget.reason.id!;
                              final updated = IncomeExpenseReasons(
                                name: nameController.text,
                                type: labelToType[selectedType]!,
                              );
                              context.read<MenuCubit>().updateReason(
                                updated,
                                id,
                              );
                              Navigator.pop(context, true);
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
            );
          }

          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
