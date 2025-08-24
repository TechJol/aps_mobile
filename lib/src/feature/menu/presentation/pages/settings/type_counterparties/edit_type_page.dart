// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditTypePage extends StatefulWidget {
  const EditTypePage({super.key, this.type});
  final PartnerTypesModel? type;

  @override
  State<EditTypePage> createState() => _EditTypePageState();
}

class _EditTypePageState extends State<EditTypePage> {
  final nameController = TextEditingController();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.type?.name ?? '';
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
        title: t.menu.typeCounterparties.editType,
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuError) {
            final snackBar = SnackBar(content: Text(state.message));
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
                  TextFieldWid(
                    label: t.menu.typeCounterparties.name,
                    controller: nameController,
                  ),
                  24.h,
                  ElevatedButton(
                    onPressed:
                        isFormValid
                            ? () async {
                              final id = widget.type?.id;
                              final partnerType = PartnerTypesModel(
                                name: nameController.text,
                              );
                              await context.read<MenuCubit>().updatePartnerType(
                                partnerType,
                                id!,
                              );

                              Navigator.pop(context, true); // <-- ВАЖНО
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
            ),
          ],
        ),
      ),
    );
  }
}
