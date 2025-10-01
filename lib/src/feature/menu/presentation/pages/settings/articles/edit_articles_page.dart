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
  String? selectedType;
  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid = nameController.text.isNotEmpty && selectedType != null;
    });
  }

  @override
  void initState() {
    nameController.text = widget.reason.name;
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
    /// 🔹 Локализованные словари
    final typeToLabel = {
      'income': t.menu.articles.income,
      'expense': t.menu.articles.expense,
    };

    final labelToType = {
      t.menu.articles.income: 'income',
      t.menu.articles.expense: 'expense',
    };

    // Инициализация выбранного типа (только при первом билде)
    selectedType ??= typeToLabel[widget.reason.type];

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.articles.editArticle,
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
                  TextFieldWid(
                    label: t.menu.articles.name,
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    items: typeToLabel.values.toList(),
                    label: t.menu.articles.type,
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
                      t.menu.save,
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
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
