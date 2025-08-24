import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
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
  final nameController = TextEditingController();
  final contactInfoController = TextEditingController();

  int? selectedTypeId;
  String? selectedTypeName;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.partner?.name ?? '';
    contactInfoController.text = widget.partner?.contactInfo ?? '';

    // загружаем типы контрагентов
    context.read<MenuCubit>().getPartnerData();

    nameController.addListener(checkFormValidity);
    contactInfoController.addListener(checkFormValidity);
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
  void dispose() {
    nameController.removeListener(checkFormValidity);
    contactInfoController.removeListener(checkFormValidity);
    nameController.dispose();
    contactInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.counterparties.editCounterparty,
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is PartnerUpdated) {
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
                  TextFieldWid(
                    label: t.menu.counterparties.name,
                    controller: nameController,
                  ),
                  12.h,
                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      if (state is MenuPartnerDataSuccess) {
                        final types = state.partnerTypes;

                        // Автоматическая инициализация выбора при первом построении
                        if (selectedTypeId == null && widget.partner != null) {
                          final matched = types!.firstWhere(
                            (e) => e.id == widget.partner!.type,
                            orElse: () => types.first,
                          );
                          selectedTypeId = matched.id;
                          selectedTypeName = matched.name;
                        }

                        return DropDownFormField(
                          label: t.menu.counterparties.type,
                          items: types!.map((e) => e.name).toList(),
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
                    label: t.menu.counterparties.phoneNumber,
                    controller: contactInfoController,
                  ),
                  24.h,
                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  final id = widget.partner!.id;
                                  final updated = PartnersModel(
                                    name: nameController.text,
                                    contactInfo: contactInfoController.text,
                                    type: selectedTypeId!,
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
                          t.menu.save,
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
