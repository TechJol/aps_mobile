import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final int rowsPerPage = 10;
  int currentPage = 1;

  final List<Map<String, String>> data = List.generate(223, (index) {
    return {
      '№': '${index + 1}',
      'Сумма': '1455',
      'Вл': 'kgs',
      'Дата': '12.01.2025',
      'Тип': 'Расход',
      'Счет': 'Офис касса',
      'Статьи': 'Внутренние переводы',
      'Контрагент': 'ОсОО Кашгар',
      'ВлТекст': 'Подробный текст',
    };
  });

  void goToPage(int page) {
    if (page >= 1 && page <= (data.length / rowsPerPage).ceil()) {
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    final pageCount = (data.length / rowsPerPage).ceil();

    // Вычислим диапазон для кнопок пагинации (только 10 отображается)
    int startPage = (currentPage - 5).clamp(1, pageCount - 9);
    int endPage = (startPage + 9).clamp(1, pageCount);
    if (endPage - startPage < 9) {
      startPage = (endPage - 9).clamp(1, pageCount);
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Транзакции',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                OutlinedButtonWidget(text: 'Транзакции', onPressed: () {}),
                12.w,
                OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 32,
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFF6C2BD9),
                  ),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataRowColor: WidgetStateProperty.all(Colors.white),
                  columns: const [
                    DataColumn(label: Text('№')),
                    DataColumn(label: Text('Сумма')),
                    DataColumn(label: Text('Вл')),
                    DataColumn(label: Text('Дата')),
                    DataColumn(label: Text('Тип')),
                    DataColumn(label: Text('Счет')),
                    DataColumn(label: Text('Статьи')),
                    DataColumn(label: Text('Контрагент')),
                    DataColumn(label: Text('Вл')),
                  ],
                  rows:
                      paginatedData.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row['№']!)),
                            DataCell(Text(row['Сумма']!)),
                            DataCell(Text(row['Вл']!)),
                            DataCell(Text(row['Дата']!)),
                            DataCell(Text(row['Тип']!)),
                            DataCell(Text(row['Счет']!)),
                            DataCell(Text(row['Статьи']!)),
                            DataCell(Text(row['Контрагент']!)),
                            DataCell(Text(row['ВлТекст']!)),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed:
                      currentPage > 1 ? () => goToPage(currentPage - 1) : null,
                ),
                if (currentPage > 4) ...[
                  pageButton(1),
                  pageButton(2),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("..."),
                  ),
                ],
                for (int i = currentPage - 2; i <= currentPage + 2; i++)
                  if (i >= 1 && i <= pageCount) pageButton(i),
                if (currentPage < pageCount - 3) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("..."),
                  ),
                  pageButton(pageCount - 1),
                  pageButton(pageCount),
                ],
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      currentPage < pageCount
                          ? () => goToPage(currentPage + 1)
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget pageButton(int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: page == currentPage ? const Color(0xFF6C2BD9) : null,
          foregroundColor: page == currentPage ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onPressed: () => goToPage(page),
        child: Text('$page'),
      ),
    );
  }
}
