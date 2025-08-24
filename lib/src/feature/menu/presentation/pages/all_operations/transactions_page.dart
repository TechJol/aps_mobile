import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
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
        title: t.menu.transactions.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }
          if (state is MenuTransactionsWithAccountsSuccess) {
            final transactions = state.transactions;
            final accounts = state.accounts;
            final reasons = state.reasons;

            if (transactions.isEmpty) {
              return Center(child: Text(t.menu.transactions.notFound));
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
                  name: t.menu.common.unknown,
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
                  name: t.menu.common.unknown,
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
            orElse:
                () => PartnersModel(name: t.menu.common.unknown, company: 0),
          )
          .name;
    }

    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    final pageCount = (data.length / rowsPerPage).ceil();

    // ===== Настройки таблицы =====
    const borderColor = Color(0xFFE6E6E6);
    const colW = {
      0: FixedColumnWidth(50), // №
      1: FixedColumnWidth(100), // Сумма
      2: FixedColumnWidth(50), // Валюта (кратко)
      3: FixedColumnWidth(90), // Дата
      4: FixedColumnWidth(70), // Тип
      5: FixedColumnWidth(120), // Счет
      6: FixedColumnWidth(150), // Статья
      7: FixedColumnWidth(150), // Контрагент
      8: FixedColumnWidth(200), // Комментарий
    };

    Widget cell(String text, {bool isHeader = false, Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          text,
          style:
              isHeader
                  ? const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                  : AppTextStyles.f14w500.copyWith(
                    color: color ?? AppColors.blackColor,
                  ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // ===== Формируем строки таблицы =====
    final tableRows = <TableRow>[];
    // Шапка
    tableRows.add(
      TableRow(
        decoration: const BoxDecoration(color: AppColors.primaryColorLight),
        children: [
          cell(t.menu.common.numberSign, isHeader: true),
          cell(t.menu.transactions.table.amount, isHeader: true),
          cell(t.menu.transactions.table.currencyShort, isHeader: true),
          cell(t.menu.transactions.table.date, isHeader: true),
          cell(t.menu.transactions.table.type, isHeader: true),
          cell(t.menu.transactions.table.account, isHeader: true),
          cell(t.menu.transactions.table.article, isHeader: true),
          cell(t.menu.transactions.table.counterparty, isHeader: true),
          cell(t.menu.transactions.table.comment, isHeader: true),
        ],
      ),
    );

    // Данные
    for (final tx in paginatedData) {
      tableRows.add(
        TableRow(
          children: [
            cell('${data.indexOf(tx) + 1}'),
            cell(tx.amount?.toString() ?? ''),
            cell(tx.currency ?? ''),
            cell(
              tx.date != null
                  ? DateFormat('dd.MM.yyyy').format(DateTime.parse(tx.date!))
                  : '',
            ),
            cell(
              tx.transactionType == 'income'
                  ? t.menu.articles.income
                  : t.menu.articles.expense,
            ),
            cell(getAccountName(tx.account ?? 0)),
            cell(getReasonName(tx.incomeExpenseReason ?? 0)),
            cell(getPartnerName(tx.partners ?? 0)),
            cell(tx.description ?? ''),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // ===== Кнопки =====
          Row(
            children: [
              OutlinedButtonWidget(
                text: t.menu.common.print,
                onPressed: () {
                  final headers = [
                    t.menu.common.numberSign,
                    t.menu.transactions.table.amount,
                    t.menu.transactions.table.currency,
                    t.menu.transactions.table.date,
                    t.menu.transactions.table.type,
                    t.menu.transactions.table.account,
                    t.menu.transactions.table.article,
                    t.menu.transactions.table.counterparty,
                    t.menu.transactions.table.comment,
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
                          tx.transactionType == 'income'
                              ? t.menu.articles.income
                              : t.menu.articles.expense,
                          getAccountName(tx.account ?? 0),
                          getReasonName(tx.incomeExpenseReason ?? 0),
                          getPartnerName(tx.partners ?? 0),
                          tx.description ?? '',
                        ];
                      }).toList();

                  _localService.printReportAsPdf(
                    context: context,
                    title: t.menu.transactions.printTitle,
                    headers: headers,
                    rows: rows,
                  );
                },
              ),
              12.w,
              OutlinedButtonWidget(
                text: t.menu.common.export,
                onPressed: () {
                  final headers = [
                    t.menu.common.numberSign,
                    t.menu.transactions.table.amount,
                    t.menu.transactions.table.currency,
                    t.menu.transactions.table.date,
                    t.menu.transactions.table.type,
                    t.menu.transactions.table.account,
                    t.menu.transactions.table.article,
                    t.menu.transactions.table.counterparty,
                    t.menu.transactions.table.comment,
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
                          tx.transactionType == 'income'
                              ? t.menu.articles.income
                              : t.menu.articles.expense,
                          getAccountName(tx.account ?? 0),
                          getReasonName(tx.incomeExpenseReason ?? 0),
                          getPartnerName(tx.partners ?? 0),
                          tx.description ?? '',
                        ];
                      }).toList();

                  _localService.exportToExcelGeneric(
                    fileName: t.menu.transactions.fileName,
                    headers: headers,
                    rows: rows,
                    context: context,
                  );
                },
              ),
            ],
          ),
          20.h,

          // ===== Таблица =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: borderColor, width: 1),
              columnWidths: colW,
              children: tableRows,
            ),
          ),
          20.h,

          // ===== Пагинация =====
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
    int endPage = (startPage + 9).clamp(startPage, pageCount);

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
