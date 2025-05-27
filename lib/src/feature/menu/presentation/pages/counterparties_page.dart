import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

class CounterpartiesPage extends StatefulWidget {
  const CounterpartiesPage({super.key});

  @override
  State<CounterpartiesPage> createState() => _CounterpartiesPageState();
}

class _CounterpartiesPageState extends State<CounterpartiesPage> {
  int currentPage = 1;
  final int rowsPerPage = 10;
  String activeCategory = 'Клиент aps';

  final List<Map<String, String>> data = List.generate(223, (index) {
    return {
      '№': '${index + 1}',
      'Имя': 'ИП Игор',
      'Баланс': '12100',
      'Контакты': '0700861212',
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
    final pageCount = (data.length / rowsPerPage).ceil();
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Категории контрагентов',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  categoryButton(
                    label: 'Клиент aps',
                    isActive: activeCategory == 'Клиент aps',
                  ),
                  8.w,
                  categoryButton(
                    label: 'Поставщик aps',
                    isActive: activeCategory == 'Поставщик aps',
                  ),
                  8.w,
                  categoryButton(
                    label: 'Сотрудник aps',
                    isActive: activeCategory == 'Сотрудник aps',
                  ),
                ],
              ),
            ),
            20.h,
            DataTable(
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
                DataColumn(label: Text('Имя')),
                DataColumn(label: Text('Баланс')),
                DataColumn(label: Text('Контакты')),
              ],
              rows:
                  paginatedData.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(Text(row['№']!)),
                        DataCell(Text(row['Имя']!)),
                        DataCell(Text(row['Баланс']!)),
                        DataCell(Text(row['Контакты']!)),
                      ],
                    );
                  }).toList(),
            ),
            16.h,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed:
                        currentPage > 1
                            ? () => goToPage(currentPage - 1)
                            : null,
                  ),
                  ..._buildPageButtons(pageCount),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        currentPage < pageCount
                            ? () => goToPage(currentPage + 1)
                            : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton({required String label, required bool isActive}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive ? Colors.black : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
        side: BorderSide(color: isActive ? Colors.black : Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {
        setState(() {
          activeCategory = label;
        });
      },
      child: Text(label),
    );
  }

  List<Widget> _buildPageButtons(int pageCount) {
    List<Widget> widgets = [];

    if (pageCount <= 5) {
      for (int i = 1; i <= pageCount; i++) {
        widgets.add(pageButton(i));
      }
    } else if (currentPage <= 3) {
      for (int i = 1; i <= 5; i++) {
        widgets.add(pageButton(i));
      }
      widgets.add(_ellipsis());
      widgets.add(pageButton(pageCount));
    } else if (currentPage >= pageCount - 2) {
      widgets.add(pageButton(1));
      widgets.add(_ellipsis());
      for (int i = pageCount - 4; i <= pageCount; i++) {
        widgets.add(pageButton(i));
      }
    } else {
      widgets.add(pageButton(1));
      widgets.add(_ellipsis());
      for (int i = currentPage - 2; i <= currentPage + 2; i++) {
        widgets.add(pageButton(i));
      }
      widgets.add(_ellipsis());
      widgets.add(pageButton(pageCount));
    }

    return widgets;
  }

  Widget _ellipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Text('...'),
    );
  }

  Widget pageButton(int page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
              page == currentPage ? AppColors.primaryColorLight : null,
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
