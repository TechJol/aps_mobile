import 'dart:developer';

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterpartiesPage extends StatefulWidget {
  const CounterpartiesPage({super.key});

  @override
  State<CounterpartiesPage> createState() => _CounterpartiesPageState();
}

class _CounterpartiesPageState extends State<CounterpartiesPage> {
  @override
  initState() {
    super.initState();
    context.read<MenuCubit>().getPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Контрагенты',
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
          if (state is MenuPartnerSuccess) {
            final partners = state.partners;
            if (partners.isEmpty) {
              return const Center(child: Text('Нет контрагентов'));
            }
            return _buildTableSection(partners);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Column _buildTableSection(List<PartnersModel> partners) {
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
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addCounterparties,
                          );
                        },
                        label: const Text(
                          'Добавить контрагента',
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

        Container(
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
              DataColumn(label: Text('Название', style: AppTextStyles.f16w500)),
              DataColumn(label: Text('Тип', style: AppTextStyles.f16w500)),
              DataColumn(label: Text('')), // для меню с тремя точками
            ],
            rows:
                partners.map((partner) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(partner.name, style: AppTextStyles.f16w500),
                      ),
                      DataCell(
                        Text('${partner.type}', style: AppTextStyles.f16w500),
                      ),

                      DataCell(
                        PopupMenuWid(
                          context: context,
                          tapDelete: () {
                            ShowSheet().showDeleteDialog(
                              context,
                              accountName: partner.name,

                              onConfirm: () {
                                log('Удаляем: ${partner.type}');
                                context.read<MenuCubit>().deletePartner(
                                  partner.id!,
                                );
                              },
                              title: 'Удалить счет',
                            );
                          },
                          tapEdit: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.editCounterparties,
                              arguments: partner, // Передача объекта партнера
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
