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

  List<PartnerTypesModel> _types = [];
  int? selectedTypeId;
  String? selectedTypeName;

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkFormValidity);
    contactInfoController.addListener(checkFormValidity);

    final currentState = context.read<MenuCubit>().state;
    if (currentState is MenuPartnerDataSuccess) {
      _types = currentState.partnerTypes ?? [];
    }

    context.read<MenuCubit>().getPartnerData();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: t.menu.counterparties.addCounterparty,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is PartnerUpdated) {
            Navigator.pop(context);
          }
          if (state is MenuPartnerDataSuccess) {
            final types = state.partnerTypes ?? [];
            setState(() {
              _types = types;
              if (selectedTypeId != null &&
                  !_types.any((e) => e.id == selectedTypeId)) {
                selectedTypeId = null;
                selectedTypeName = null;
              }
            });
            checkFormValidity();
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
                color: Theme.of(context).colorScheme.surface,
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
                  DropDownFormField(
                    label: t.menu.counterparties.type,
                    items: _types.map((e) => e.name).toList(),
                    value: selectedTypeName,
                    onChanged: (val) {
                      if (val == null) {
                        return;
                      }
                      final selected = _types.firstWhere((e) => e.name == val);
                      setState(() {
                        selectedTypeId = selected.id;
                        selectedTypeName = selected.name;
                      });
                      checkFormValidity();
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
                        onPressed: isFormValid
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
