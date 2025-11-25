// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPartnerBottomSheet {
  static Future<bool?> show(
    BuildContext context,
    AllTransactionsModel transaction,
  ) async {
    final cubit = context.read<MenuCubit>();
    final currentState = cubit.state;

    List<PartnersModel> partners = [];
    List<PartnerTypesModel> partnerTypes = [];

    if (currentState is MenuTransactionsWithAccountsSuccess) {
      partners = currentState.partners;
      partnerTypes = currentState.partnerTypes!;
    } else if (currentState is MenuPartnerDataSuccess) {
      partners = currentState.partners ?? [];
      partnerTypes = currentState.partnerTypes ?? [];
    } else {
      await cubit.getPartnerData(force: true);
      final newState = cubit.state;
      if (newState is MenuPartnerDataSuccess) {
        partners = newState.partners ?? [];
        partnerTypes = newState.partnerTypes ?? [];
      }
    }

    if (partners.isEmpty && partnerTypes.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.operation.notFoundPartner)));
      return null;
    }

    String? selectedType;
    String? selectedPartner;
    List<PartnersModel> filteredPartners = partners;

    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      enableDrag: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              title: Text(t.operation.addPartner, style: AppTextStyles.f22w500),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.operation.selectTypeAndPartner,
                    style: AppTextStyles.f14w500.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    label: t.operation.selectType,
                    items: partnerTypes.map((type) => type.name).toList(),
                    value: selectedType ?? '',
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                        final id = partnerTypes
                            .firstWhere((type) => type.name == value)
                            .id;
                        filteredPartners = partners
                            .where((p) => p.type == id)
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropDownFormField(
                    label: t.operation.selectPartner,
                    items: filteredPartners
                        .map((partner) => partner.name)
                        .toList(),
                    value: selectedPartner ?? '',
                    onChanged: (value) => setState(() {
                      selectedPartner = value;
                    }),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.backroundColor,
                          side: const BorderSide(
                            color: AppColors.backroundColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          t.operation.cancel,
                          style: AppTextStyles.f16w500.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedPartner == null) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(t.operation.selectPartner),
                              ),
                            );
                            return;
                          }

                          final partnerId = filteredPartners
                              .firstWhere(
                                (partner) => partner.name == selectedPartner,
                                orElse: () => PartnersModel(id: null, name: ''),
                              )
                              .id;

                          if (partnerId == null) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(t.operation.notFoundPartner),
                              ),
                            );
                            return;
                          }

                          await cubit.updatePartnerInTransaction(
                            transaction,
                            partnerId,
                          );
                          await cubit.getTransactionsWithAccounts(force: true);
                          Navigator.of(dialogContext).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          t.operation.yes,
                          style: AppTextStyles.f16w500.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
