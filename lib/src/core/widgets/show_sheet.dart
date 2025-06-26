import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowSheet {
  Future<void> showDeleteDialog(
    BuildContext context, {
    required String accountName,
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
            'Вы уверены, что хотите удалить счет "$accountName"?',
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

  Future<void> showAddPartnerSheed(
    BuildContext context, {
    required void Function()? onConfirm,
    required String title,
  }) {
    context.read<MenuCubit>().getPartnerData();
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
          title: Text('Добавить контрагент', style: AppTextStyles.f22w500),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выберите тип и партнера',
                style: AppTextStyles.f16w500.copyWith(
                  color: AppColors.greyerColorLight,
                ),
              ),
              SizedBox(height: 8),
              BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuPartnerDataSuccess) {
                    if (state is MenuLoading) {
                      return const CircularProgressIndicator();
                    }
                    return DropDownFormField(
                      label: 'Выберите тип',
                      items:
                          state.partnerTypes!.map((type) => type.name).toList(),
                      value: '',
                      onChanged: (selectedType) {
                        // Фильтруем партнеров по выбранному типу (ID)
                        final selectedTypeId =
                            state.partnerTypes!
                                .firstWhere((type) => type.name == selectedType)
                                .id;
                        context.read<MenuCubit>().filterPartnersByType(
                          selectedTypeId!,
                        );
                      },
                    );
                  }
                  return const Text('Нет данных');
                },
              ),
              SizedBox(height: 8),
              BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuPartnerDataSuccess) {
                    if (state is MenuLoading) {
                      return const CircularProgressIndicator();
                    }

                    // Получаем отфильтрованных партнеров по выбранному типу
                    final filteredPartners = state.filteredPartners;

                    // Отображаем список партнеров, если они есть
                    return DropDownFormField(
                      label: 'Выберите партнера',
                      items:
                          filteredPartners!
                              .map(
                                (partner) => partner.name,
                              ) // Отображаем имя партнера
                              .toList(),
                      value: '',
                      onChanged: (val) {
                        // Здесь можно работать с ID партнера, отправить его в дальнейшем
                      },
                    );
                  }
                  return const Text('Нет данных');
                },
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
}
