import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForCounterpartiesPage extends StatefulWidget {
  const ForCounterpartiesPage({super.key});

  @override
  State<ForCounterpartiesPage> createState() => _ForCounterpartiesPageState();
}

class _ForCounterpartiesPageState extends State<ForCounterpartiesPage> {
  int currentPage = 1;
  final int rowsPerPage = 10;
  String activeCategory = 'Клиент aps';

  @override
  void initState() {
    context.read<MenuCubit>().getPartners();
    super.initState();
  }

  final List<Map<String, String>> data = List.generate(223, (index) {
    return {
      '№': '${index + 1}',
      'Имя': 'ИП Игор',
      'Баланс': '12100',
      'Контакты': '0700861212',
    };
  });

  void goToPage(int page, int pageCount) {
    if (page >= 1 && page <= pageCount) {
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Категории контрагентов',
        backgroundColor: AppColors.whiteColor,
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
            return _buildTableWithPagination(partners);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildTableWithPagination(List<PartnersModel> data) {
    final pageCount = (data.length / rowsPerPage).ceil();
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    return Padding(
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
                paginatedData.asMap().entries.map((entry) {
                  final tx = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(tx.id.toString())),
                      DataCell(Text(tx.name)),
                      DataCell(Text('1000')),
                      DataCell(Text(tx.contactInfo)),
                    ],
                  );
                }).toList(),
          ),
          16.h,
          _buildPagination(pageCount),
        ],
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

  Widget _buildPagination(int pageCount) {
    if (pageCount <= 1) {
      return const SizedBox.shrink(); // не показываем пагинацию если одна страница
    }

    int startPage = (currentPage - 5).clamp(1, pageCount);
    int endPage = (startPage + 9).clamp(
      startPage,
      pageCount,
    ); // гарантируем, что end >= start

    if (endPage - startPage < 9) {
      startPage = (endPage - 9).clamp(1, pageCount);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                currentPage > 1
                    ? () => goToPage(currentPage - 1, pageCount)
                    : null,
          ),
          for (int i = startPage; i <= endPage; i++) _pageButton(i, pageCount),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                currentPage < pageCount
                    ? () => goToPage(currentPage + 1, pageCount)
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _pageButton(int page, int pageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
              page == currentPage ? AppColors.primaryColorLight : null,
          foregroundColor: page == currentPage ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: () => goToPage(page, pageCount),
        child: Text('$page'),
      ),
    );
  }
}
