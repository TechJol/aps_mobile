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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$total с', style: AppTextStyles.f24w600),
          Text(
            'общий баланс',
            style: AppTextStyles.f14w500.copyWith(color: AppColors.greyColor),
          ),
          20.h,
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
                          acc.accountType,
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
                          acc.accountType,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                  paginatedData.asMap().entries.map((entry) {
                    final tx = entry.value;
                    final balance = calculateAccountBalance(
                      accountId: tx.id!,
                      transactions: transactions,
                    );
                    return DataRow(
                      cells: [
                        DataCell(Text(tx.id.toString())),
                        DataCell(Text(tx.name)),
                        DataCell(Text('$balance с')),
                        DataCell(Text(tx.accountType)),
                      ],
                    );
                  }).toList(),
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
