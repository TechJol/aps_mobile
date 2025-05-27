import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class MenuAccountsPage extends StatefulWidget {
  const MenuAccountsPage({super.key});

  @override
  State<MenuAccountsPage> createState() => _MenuAccountsPageState();
}

class _MenuAccountsPageState extends State<MenuAccountsPage> {
  final int rowsPerPage = 10;
  int currentPage = 1;

  final List<Map<String, String>> data = List.generate(223, (index) {
    return {
      '№': '${index + 1}',
      'Название': '1455',
      'Баланс': 'kgs',
      'Тип счета': '12.01.2025',
    };
  });

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.whiteColor,
        title: 'По счетам',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('96 512 с', style: AppTextStyles.f24w600),
            Text(
              'общий баланс',
              style: AppTextStyles.f14w500.copyWith(color: AppColors.greyColor),
            ),
            20.h,
            Row(
              children: [
                OutlinedButtonWidget(text: 'Транзакции', onPressed: () {}),
                12.w,
                OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
              ],
            ),
            20.h,
            SingleChildScrollView(
              child: DataTable(
                columnSpacing: 44,
                headingRowColor: WidgetStateProperty.all(
                  AppColors.primaryColorLight,
                ),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                dataRowColor: WidgetStateProperty.all(Colors.white),
                columns: const [
                  DataColumn(label: Text('№')),
                  DataColumn(label: Text('Название')),
                  DataColumn(label: Text('Баланс')),
                  DataColumn(label: Text('Тип счета')),
                ],
                rows:
                    paginatedData.map((row) {
                      return DataRow(
                        cells: [
                          DataCell(Text(row['№']!)),
                          DataCell(Text(row['Название']!)),
                          DataCell(Text(row['Баланс']!)),
                          DataCell(Text(row['Тип счета']!)),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
