import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class ShowSheet {
  Future<void> showDeleteDialog(
    BuildContext context, {
    String? accountName,
    required void Function()? onConfirm,
    required String title,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // нельзя закрыть тапом вне окна
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: Text(title, style: AppTextStyles.f22w500),
          content: Text(
            'Вы уверены, что хотите удалить "$accountName"?',
            style: AppTextStyles.f16w500.copyWith(
              color: AppColors.greyerColorLight,
            ),
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.backroundColor,
                      side: BorderSide(color: AppColors.backroundColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Отмена',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // закрыть диалог
                      if (onConfirm != null) onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Да',
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
  }

  // Future<void> showAddPartnerSheed(
  //   BuildContext context, {
  //   required void Function()? onConfirm,
  //   required String title,
  // }) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       bool loaded = false;

  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           // Вызываем getPartnerData только один раз
  //           if (!loaded) {
  //             context.read<MenuCubit>().getPartnerData();
  //             loaded = true;
  //           }

  //           return BlocBuilder<MenuCubit, MenuState>(
  //             builder: (context, state) {
  //               if (state is MenuLoading) {
  //                 return const Center(child: CircularProgressIndicator());
  //               }

  //               if (state is! MenuPartnerDataSuccess) {
  //                 return const AlertDialog(
  //                   title: Text('Ошибка'),
  //                   content: Text('Не удалось загрузить данные.'),
  //                 );
  //               }

  //               return AlertDialog(
  //                 backgroundColor: AppColors.whiteColor,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 contentPadding: const EdgeInsets.all(20),
  //                 title: Text(
  //                   'Добавить контрагента',
  //                   style: AppTextStyles.f22w500,
  //                 ),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       'Выберите тип и партнера',
  //                       style: AppTextStyles.f16w500.copyWith(
  //                         color: AppColors.greyerColorLight,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     DropDownFormField(
  //                       label: 'Выберите тип',
  //                       items:
  //                           state.partnerTypes!
  //                               .map((type) => type.name)
  //                               .toList(),
  //                       value: '',
  //                       onChanged: (selectedType) {
  //                         final selectedTypeId =
  //                             state.partnerTypes!
  //                                 .firstWhere(
  //                                   (type) => type.name == selectedType,
  //                                 )
  //                                 .id;
  //                         context.read<MenuCubit>().filterPartnersByType(
  //                           selectedTypeId!,
  //                         );
  //                       },
  //                     ),
  //                     const SizedBox(height: 8),
  //                     DropDownFormField(
  //                       label: 'Выберите партнера',
  //                       items:
  //                           (state.filteredPartners ?? [])
  //                               .map((partner) => partner.name)
  //                               .toList(),
  //                       value: '',
  //                       onChanged: (val) {
  //                         // Можно сохранить ID партнера тут
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 actionsPadding: const EdgeInsets.symmetric(
  //                   horizontal: 16,
  //                   vertical: 10,
  //                 ),
  //                 actions: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: OutlinedButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                           },
  //                           style: OutlinedButton.styleFrom(
  //                             backgroundColor: AppColors.backroundColor,
  //                             side: BorderSide(color: AppColors.backroundColor),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'Отмена',
  //                             style: AppTextStyles.f16w500.copyWith(
  //                               color: AppColors.blackColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: ElevatedButton(
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             if (onConfirm != null) onConfirm();
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: AppColors.primaryColorLight,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             'Да',
  //                             style: AppTextStyles.f16w500.copyWith(
  //                               color: AppColors.whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
