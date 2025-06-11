import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/menu/presentation/cubit/menu_cubit.dart';
import 'package:aps_mobile/src/feature/menu/data/models/all_transactions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  /// сколько строк показываем на странице
  final int rowsPerPage = 10;

  /// текущая страница (с 1)
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    // загружаем реальные данные
    context.read<MenuCubit>().getTransactions();
  }

  /// перейти на страницу [page]
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
        title: 'Транзакции',
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
          if (state is MenuSuccess) {
            final transactions = state.transactions;
            if (transactions.isEmpty) {
              return const Center(child: Text('Нет транзакций'));
            }
            return _buildTableWithPagination(transactions);
          }
          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Таблица + пагинация
  Widget _buildTableWithPagination(List<AllTransactionsModel> data) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    final pageCount = (data.length / rowsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              OutlinedButtonWidget(text: 'Транзакции', onPressed: () {}),
              12.w,
              OutlinedButtonWidget(
                text: 'Скачать в Excel',
                onPressed: () {
                  // TODO: реализовать экспорт
                },
              ),
            ],
          ),
          20.h,
          // --------------- таблица ---------------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 32,
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
                DataColumn(label: Text('Сумма')),
                DataColumn(label: Text('Вл')),
                // DataColumn(label: Text('Дата')),
                DataColumn(label: Text('Тип')),
                // DataColumn(label: Text('Счет')),
                // DataColumn(label: Text('Статьи')),
                // DataColumn(label: Text('Контрагент')),
                // DataColumn(label: Text('Комментарий')),
              ],
              rows:
                  paginatedData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tx = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(tx.id.toString())),
                        DataCell(Text(tx.amount.toString())),
                        DataCell(Text(tx.currency ?? '')),
                        // DataCell(Text(tx.date != null ? DateFormat('dd.MM.yyyy').format(tx.date!) : '')),
                        DataCell(Text(tx.transactionType ?? '')),
                        // DataCell(Text(tx.account ?? '')),
                        // DataCell(Text(tx. ?? '')),
                        // DataCell(Text(tx.counterpartyName ?? '')),
                        // DataCell(Text(tx.comment ?? '')),
                      ],
                    );
                  }).toList(),
            ),
          ),
          20.h,
          // --------------- пагинация ---------------
          _buildPagination(pageCount),
        ],
      ),
    );
  }

  Widget _buildPagination(int pageCount) {
    // вычисляем диапазон кнопок (не более 10)
    int startPage = (currentPage - 5).clamp(1, pageCount - 9);
    int endPage = (startPage + 9).clamp(1, pageCount);
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
          if (currentPage > 4) ...[
            _pageButton(1, pageCount),
            _pageButton(2, pageCount),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            ),
          ],
          for (int i = currentPage - 2; i <= currentPage + 2; i++)
            if (i >= 1 && i <= pageCount) _pageButton(i, pageCount),
          if (currentPage < pageCount - 3) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            ),
            _pageButton(pageCount - 1, pageCount),
            _pageButton(pageCount, pageCount),
          ],
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
