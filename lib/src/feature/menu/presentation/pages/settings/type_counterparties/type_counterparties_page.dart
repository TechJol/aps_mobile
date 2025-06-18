import 'dart:developer';

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeCounterpartiesPage extends StatefulWidget {
  const TypeCounterpartiesPage({super.key});

  @override
  State<TypeCounterpartiesPage> createState() => _TypeCounterpartiesPageState();
}

class _TypeCounterpartiesPageState extends State<TypeCounterpartiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getPartnerTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Типы контрагентов',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          if (state is MenuPartnerTypesSuccess) {
            final types = state.types;
            return _buildTableSection(context, types);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Column _buildTableSection(
    BuildContext context,
    List<PartnerTypesModel> types,
  ) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                20.h,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.addType);
                        },
                        label: const Text(
                          'Добавить тип',
                          style: AppTextStyles.f16w500,
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorLight,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ],
                ),
                12.h,
                Row(
                  children: [
                    OutlinedButtonWidget(onPressed: () {}, text: 'Распечатать'),
                    12.w,
                    OutlinedButtonWidget(
                      onPressed: () {},
                      text: 'Скачать в Excel',
                    ),
                  ],
                ),
                20.h,
              ],
            ),
          ),
        ),
        12.h,

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DataTable(
                showCheckboxColumn: true,
                showBottomBorder: true,
                headingRowColor: WidgetStateProperty.all(Colors.black),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                columns: const [
                  DataColumn(
                    label: Text('Название', style: AppTextStyles.f16w500),
                  ),
                  DataColumn(label: Text('')),
                ],
                rows:
                    types.map((type) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                type.name,
                                style: AppTextStyles.f16w500,
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.centerRight,
                              child: PopupMenuWid(
                                context: context,
                                tapDelete: () {
                                  ShowSheet().showDeleteDialog(
                                    context,
                                    accountName: type.name,
                                    onConfirm: () {
                                      log('Удаляем: ${type.name}');
                                    },
                                    title: 'Удалить счет',
                                  );
                                },
                                tapEdit: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.editType,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
