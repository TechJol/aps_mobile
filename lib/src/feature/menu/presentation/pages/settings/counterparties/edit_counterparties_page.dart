import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCounterpartiesPage extends StatefulWidget {
  const EditCounterpartiesPage({super.key, this.partner});

  final PartnersModel? partner;

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

    // Инициализация контроллеров
    nameController.text = widget.partner?.name ?? '';
    contactInfoController.text = widget.partner?.contactInfo ?? '';
    final typeIndex = (widget.partner?.type ?? 1) - 1;
    if (typeIndex >= 0 && typeIndex < types.length) {
      selectedType = types[typeIndex];
    }

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
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuLoading) {
            Center(child: CircularProgressIndicator());
          }
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

                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () async {
                                  final id = widget.partner!.id;
                                  final updated = PartnersModel(
                                    name: nameController.text,
                                    contactInfo: contactInfoController.text,
                                    type: types.indexOf(selectedType!) + 1,
                                  );

                                  context.read<MenuCubit>().updatePartner(
                                    updated,
                                    id!,
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
