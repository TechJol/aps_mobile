import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // bool showTable = false;

  // Пример данных таблицы
  final List<Map<String, String>> accounts = [
    {'name': 'Бакaй банк', 'type': 'банк'},
    {'name': 'Офис касса', 'type': 'касса'},
    {'name': 'Офис касса', 'type': 'касса'},
    {'name': 'Офис касса', 'type': 'касса'},
    {'name': 'Офис касса', 'type': 'касса'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.backroundColor,
        centerTitle: false,
        title: Text('Счета', style: AppTextStyles.f24w600),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
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
                            Navigator.pushNamed(context, AppRoutes.addAccount);
                          },
                          label: const Text(
                            'Добавить счет',
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
                DataColumn(
                  label: Text('Название', style: AppTextStyles.f16w500),
                ),
                DataColumn(
                  label: Text('Тип счета', style: AppTextStyles.f16w500),
                ),
                DataColumn(label: Text('')), // для меню с тремя точками
              ],
              rows:
                  accounts.map((account) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(account['name']!, style: AppTextStyles.f16w500),
                        ),
                        DataCell(
                          Text(account['type']!, style: AppTextStyles.f16w500),
                        ),

                        DataCell(
                          PopupMenuWid(
                            context: context,
                            tapDelete: () {
                              ShowSheet().showDeleteDialog(
                                context,
                                accountName: account['name']!,

                                onConfirm: () {
                                  print('Удаляем: ${account['name']}');
                                },
                                title: 'Удалить счет',
                              );
                            },
                            tapEdit: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editAccount,
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
      ),
    );
  }
}
