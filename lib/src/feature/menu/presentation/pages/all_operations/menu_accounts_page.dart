import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuAccountsPage extends StatefulWidget {
  const MenuAccountsPage({super.key});

  @override
  State<MenuAccountsPage> createState() => _MenuAccountsPageState();
}

class _MenuAccountsPageState extends State<MenuAccountsPage> {
  final LocalService _localService = LocalService();

  final int rowsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getTransactionsWithAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.whiteColor,
        title: 'По счетам',
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

            final totalBalance = calculateTotalBalance(transactions);

            return _buildTableWithPagination(
              context,
              accounts,
              totalBalance,
              transactions,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildTableWithPagination(
    BuildContext context,
    List<AccountModel> data,
    Decimal total,
    List<AllTransactionsModel> transactions,
  ) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    final hasData = paginatedData.isNotEmpty;

    const borderColor = Color(0xFFE6E6E6);
    const colW = {
      0: FixedColumnWidth(50), // №
      1: FixedColumnWidth(200), // Название
      2: FixedColumnWidth(140), // Баланс
      3: FixedColumnWidth(120), // Тип счета
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

    final tableRows = <TableRow>[];

    // Заголовок
    tableRows.add(
      TableRow(
        decoration: const BoxDecoration(color: AppColors.primaryColorLight),
        children: [
          cell('№', isHeader: true),
          cell('Название', isHeader: true),
          cell('Баланс', isHeader: true),
          cell('Тип счета', isHeader: true),
        ],
      ),
    );

    // Данные
    for (final acc in paginatedData) {
      final balance = calculateAccountBalance(
        accountId: acc.id!,
        transactions: transactions,
      );
      tableRows.add(
        TableRow(
          children: [
            cell('${data.indexOf(acc) + 1}'),
            cell(acc.name),
            cell('${balance.toString()} с'),
            cell(acc.accountType == 'cash' ? 'Касса' : 'Банк'),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasData) Text('$total с', style: AppTextStyles.f24w600),
          if (hasData)
            Text(
              'общий баланс',
              style: AppTextStyles.f14w500.copyWith(color: AppColors.greyColor),
            ),
          20.h,
          if (hasData)
            Row(
              children: [
                OutlinedButtonWidget(
                  text: 'Распечатать',
                  onPressed: () {
                    final headers = ['№', 'Название', 'Баланс', 'Тип счета'];
                    final rows =
                        data.asMap().entries.map<List<String>>((entry) {
                          final index = entry.key + 1;
                          final acc = entry.value;
                          final balance = calculateAccountBalance(
                            accountId: acc.id!,
                            transactions: transactions,
                          );
                          return [
                            '$index',
                            acc.name,
                            balance.toString(),
                            acc.accountType == 'cash' ? 'Касса' : 'Банк',
                          ];
                        }).toList();
                    _localService.printReportAsPdf(
                      context: context,
                      title: 'Отчет по счетам',
                      headers: headers,
                      rows: rows,
                    );
                  },
                ),
                12.w,
                OutlinedButtonWidget(
                  text: 'Скачать в Excel',
                  onPressed: () {
                    final headers = ['№', 'Название', 'Баланс', 'Тип счета'];
                    final rows =
                        data.asMap().entries.map<List<String>>((entry) {
                          final index = entry.key + 1;
                          final acc = entry.value;
                          final balance = calculateAccountBalance(
                            accountId: acc.id!,
                            transactions: transactions,
                          );
                          return [
                            '$index',
                            acc.name,
                            balance.toString(),
                            acc.accountType == 'cash' ? 'Касса' : 'Банк',
                          ];
                        }).toList();
                    _localService.exportToExcelGeneric(
                      fileName: 'По_счетам',
                      headers: headers,
                      rows: rows,
                      context: context,
                    );
                  },
                ),
              ],
            ),
          20.h,
          if (hasData)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(color: borderColor, width: 1),
                columnWidths: colW,
                children: tableRows,
              ),
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text('Нет данных', style: AppTextStyles.f16w500),
              ),
            ),
        ],
      ),
    );
  }

  Decimal calculateTotalBalance(List<AllTransactionsModel> transactions) {
    Decimal total = Decimal.zero;

    for (var tx in transactions) {
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }

    return total;
  }

  Decimal calculateAccountBalance({
    required int accountId,
    required List<AllTransactionsModel> transactions,
  }) {
    Decimal total = Decimal.zero;

    for (var tx in transactions) {
      if (tx.account == accountId) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

        if (tx.transactionType == 'income') {
          total += amount;
        } else if (tx.transactionType == 'expense') {
          total -= amount;
        }
      }
    }

    return total;
  }
}
