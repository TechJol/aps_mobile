import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCounterpartiesPage extends StatefulWidget {
  const AddCounterpartiesPage({super.key});

  @override
  State<AddCounterpartiesPage> createState() => _AddCounterpartiesPageState();
}

class _AddCounterpartiesPageState extends State<AddCounterpartiesPage> {
  final nameController = TextEditingController();
  final contactInfoController = TextEditingController();

  int? selectedTypeId;
  String? selectedTypeName;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
    contactInfoController.addListener(checkFormValidity);

    context.read<MenuCubit>().getPartnerTypes(); // Запрашиваем типы
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
          selectedTypeId != null &&
          nameController.text.isNotEmpty &&
          contactInfoController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Добавить контрагента',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuPartnerSuccess) {
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
                borderRadius: const BorderRadius.only(
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
                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      if (state is MenuPartnerTypesSuccess) {
                        final types = state.types;

                        return DropDownFormField(
                          label: 'Тип',
                          items: types.map((e) => e.name).toList(),
                          value: selectedTypeName,
                          onChanged: (val) {
                            final selected = types.firstWhere(
                              (e) => e.name == val,
                            );
                            setState(() {
                              selectedTypeId = selected.id;
                              selectedTypeName = selected.name;
                            });
                            checkFormValidity();
                          },
                        );
                      } else if (state is MenuLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  12.h,
                  TextFieldWid(
                    label: 'Контактная информация',
                    controller: contactInfoController,
                  ),
                  24.h,
                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  final newPartner = PartnersModel(
                                    name: nameController.text,
                                    type: selectedTypeId!,
                                    contactInfo: contactInfoController.text,
                                  );
                                  context.read<MenuCubit>().postPartner(
                                    newPartner,
                                  );
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
