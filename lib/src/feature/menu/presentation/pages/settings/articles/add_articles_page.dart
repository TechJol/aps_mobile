import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddArticlesPage extends StatefulWidget {
  const AddArticlesPage({super.key});

  @override
  State<AddArticlesPage> createState() => _AddArticlesPageState();
}

class _AddArticlesPageState extends State<AddArticlesPage> {
  final List<String> names = ['Аренда', 'Выручка'];
  final List<String> types = ['Доход', 'Расход'];
  final List<String> typesCode = ['income', 'expense'];

  String? selectedName;
  String? selectedType;
  String? selectedTypeCode;

  bool isFormValid = false;

  void checkFormValidity() {
    setState(() {
      isFormValid =
          selectedName != null &&
          selectedType != null &&
          selectedName!.isNotEmpty &&
          selectedType!.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Добавить статью',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuReasonsSuccess) {
            Navigator.pop(context);
          }
          if (state is MenuError) {
            var snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Column(
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
                        final index = types.indexOf(val ?? '');
                        selectedTypeCode =
                            index != -1 ? typesCode[index] : null;
                      });
                      checkFormValidity();
                    },
                  ),

                  const SizedBox(height: 24),

                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  final reason = IncomeExpenseReasons(
                                    name: selectedName ?? '',
                                    type: selectedTypeCode ?? '',
                                  );
                                  context.read<MenuCubit>().postReason(reason);
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
