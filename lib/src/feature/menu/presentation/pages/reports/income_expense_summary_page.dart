import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class IncomeExpenseSummaryPage extends StatelessWidget {
  const IncomeExpenseSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Общее положение',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            20.h, DataTableSectionA(), 40.h,
            //DataTableSectionB(),
          ],
        ),
      ),
    );
  }
}

//  final sorted =
//           totals.entries
//               .toList()
//               .cast<MapEntry<int, Decimal>>() // 👈 уточняем тип
//             ..sort((a, b) => b.value.compareTo(a.value));

//       return {
//         'name': reason.name,
//         'amount': entry.value.toString(),
//         'percent': sorted.indexOf(entry) / sorted.length * hundred.toDouble(),
//       };

// Таблица с данными
class DataTableSectionA extends StatelessWidget {
  const DataTableSectionA({super.key});

  @override
  Widget build(BuildContext context) {
    final int rowsPerPage = 5;
    int currentPage = 1;
    final List<Map<String, String>> data = List.generate(223, (index) {
      return {
        '№': '${index + 1}',
        'Статья дохода': 'Доход от продажи',
        'Сумма (сом)': '444544',
        'Процент': '34%',
      };
    });

    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 32,
        headingRowColor: WidgetStateProperty.all(AppColors.primaryColorLight),
        headingTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dataRowColor: WidgetStateProperty.all(Colors.white),
        columns: const [
          DataColumn(label: Text('№')),
          DataColumn(label: Text('Статья дохода')),
          DataColumn(label: Text('Сумма (сом)')),
          DataColumn(label: Text('Процент')),
        ],
        rows:
            paginatedData.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['№']!)),
                  DataCell(Text(row['Статья дохода']!)),
                  DataCell(Text(row['Сумма (сом)']!)),
                  DataCell(Text(row['Процент']!)),
                ],
              );
            }).toList(),
      ),
    );
  }
}

// class DataTableSectionB extends StatelessWidget {
//   const DataTableSectionB({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final int rowsPerPage = 5;
//     int currentPage = 1;
//     final List<Map<String, String>> data = List.generate(223, (index) {
//       return {
//         'Валюта': 'USD',
//         'Курс к KGZ': '47,45',
//         'Дата обн.': '1 мая 2025',
//       };
//     });

//     final start = (currentPage - 1) * rowsPerPage;
//     final end = (start + rowsPerPage).clamp(0, data.length);
//     final paginatedData = data.sublist(start, end);

//     return SizedBox(
//       width: double.infinity,
//       child: DataTable(
//         headingRowColor: WidgetStateProperty.all(AppColors.blackColor),
//         headingTextStyle: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//         dataRowColor: WidgetStateProperty.all(Colors.white),
//         columns: [
//           DataColumn(label: const Text('Валюта', textAlign: TextAlign.center)),
//           DataColumn(
//             label: const Text('Курс к KGZ', textAlign: TextAlign.center),
//           ),
//           DataColumn(
//             label: const Text('Дата обн.', textAlign: TextAlign.center),
//           ),
//         ],
//         rows:
//             paginatedData.map((row) {
//               return DataRow(
//                 cells: [
//                   DataCell(
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(row['Валюта']!, textAlign: TextAlign.center),
//                     ),
//                   ),
//                   DataCell(
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         row['Курс к KGZ']!,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   DataCell(
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: Text(
//                         row['Дата обн.']!,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//       ),
//     );
//   }
// }
