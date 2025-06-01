import 'dart:developer';

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class TypeCounterpartiesPage extends StatelessWidget {
  const TypeCounterpartiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> accounts = [
      {'name': 'ИП Жаркынай'},
      {'name': 'ИП Егор'},
      {'name': 'Макамбаев'},
      {'name': 'ИП Егор'},
      {'name': 'ИП Егор'},
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Типы контрагентов',
        backgroundColor: AppColors.backroundColor,
      ),
      body: Column(
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
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Распечатать',
                      ),
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
                      accounts.map((account) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  account['name']!,
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
                                      accountName: account['name']!,
                                      onConfirm: () {
                                        log('Удаляем: ${account['name']}');
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
      ),
    );
  }
}
