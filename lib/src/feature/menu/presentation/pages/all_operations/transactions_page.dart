import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final LocalService _localService = LocalService();

  /// сколько строк показываем на странице
  final int rowsPerPage = 10;

  /// текущая страница (с 1)
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    // загружаем реальные данные
    // context.read<MenuCubit>().getTransactions();
    context.read<MenuCubit>().getTransactionsWithAccounts();
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
        title: 'Все транзакции',
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
          if (state is MenuTransactionsWithAccountsSuccess) {
            final transactions = state.transactions;
            final accounts = state.accounts;
            final reasons = state.reasons;

            if (transactions.isEmpty) {
              return const Center(child: Text('Нет транзакций'));
            }
            return _buildTableWithPagination(
              transactions,
              accounts,
              reasons,
              state.partners,
            );
          }

          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Таблица + пагинация
  Widget _buildTableWithPagination(
    List<AllTransactionsModel> data,
    List<AccountModel> accounts,
    List<IncomeExpenseReasons> reasons,
    List<PartnersModel> partners,
  ) {
    String getAccountName(int id) {
      return accounts
          .firstWhere(
            (acc) => acc.id == id,
            orElse:
                () => AccountModel(
                  name: 'Неизвестно',
                  accountType: '',
                  company: 0,
                ),
          )
          .name;
    }

    String getReasonName(int id) {
      return reasons
          .firstWhere(
            (reason) => reason.id == id,
            orElse:
                () => IncomeExpenseReasons(
                  name: 'Неизвестно',
                  type: '',
                  company: 0,
                ),
          )
          .name;
    }

    String getPartnerName(int id) {
      return partners
          .firstWhere(
            (p) => p.id == id,
            orElse: () => PartnersModel(name: 'Неизвестно', company: 0),
          )
          .name;
    }

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
              OutlinedButtonWidget(text: 'Распечатать', onPressed: () {}),
              12.w,
              OutlinedButtonWidget(
                text: 'Скачать в Excel',
                onPressed: () {
                  final headers = [
                    '№',
                    'Сумма',
                    'Валюта',
                    'Дата',
                    'Тип',
                    'Счет',
                    'Статья',
                    'Контрагент',
                    'Комментарий',
                  ];

                  final rows =
                      data.asMap().entries.map<List<String>>((entry) {
                        final tx = entry.value;
                        final index = entry.key + 1;
                        return [
                          '$index',
                          tx.amount?.toString() ?? '',
                          tx.currency ?? '',
                          tx.date != null
                              ? DateFormat(
                                'dd.MM.yyyy',
                              ).format(DateTime.parse(tx.date!))
                              : '',
                          tx.transactionType ?? '',
                          getAccountName(tx.account ?? 0),
                          getReasonName(tx.incomeExpenseReason ?? 0),
                          getPartnerName(tx.partners ?? 0),
                          tx.description ?? '',
                        ];
                      }).toList();

                  _localService.exportToExcelGeneric(
                    fileName: 'Все_транзакции',
                    headers: headers,
                    rows: rows,
                    context: context,
                  );
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
                DataColumn(label: Text('Дата')),
                DataColumn(label: Text('Тип')),
                DataColumn(label: Text('Счет')),
                DataColumn(label: Text('Статьи')),
                DataColumn(label: Text('Контрагент')),
                DataColumn(label: Text('Комментарий')),
              ],
              rows:
                  paginatedData.asMap().entries.map((entry) {
                    // final index = entry.key;
                    final tx = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(tx.id.toString())),
                        DataCell(Text(tx.amount.toString())),
                        DataCell(Text(tx.currency ?? '')),
                        DataCell(
                          Text(
                            tx.date != null
                                ? DateFormat(
                                  'dd.MM.yyyy',
                                ).format(DateTime.parse(tx.date!))
                                : '',
                          ),
                        ),
                        DataCell(Text(tx.transactionType ?? '')),
                        DataCell(Text(getAccountName(tx.account ?? 0))),
                        DataCell(
                          Text(getReasonName(tx.incomeExpenseReason ?? 0)),
                        ),
                        DataCell(Text(getPartnerName(tx.partners ?? 0))),
                        DataCell(Text('${tx.description}')),
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
