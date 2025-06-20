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
  String? selectedName;
  String? selectedType;
  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid = selectedName != null && selectedType != null;
    });
  }

  @override
  void initState() {
    selectedName = widget.reason.name;
    selectedType = widget.reason.type;
    checkFormValidity();
    super.initState();
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
            final reasons = state.reasons;

            // Собираем уникальные названия
            final uniqueNames = reasons.map((e) => e.name).toSet().toList();
            final types = ['income', 'expense'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  24.h,
                  DropDownFormField(
                    items: uniqueNames,
                    label: 'Название',
                    value: selectedName,
                    onChanged: (val) {
                      setState(() => selectedName = val);
                      checkFormValidity();
                    },
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    items: types,
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
                                name: selectedName!,
                                type: selectedType!,
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
