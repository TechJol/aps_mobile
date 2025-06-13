import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuAccountsPage extends StatefulWidget {
  const MenuAccountsPage({super.key});

  @override
  State<MenuAccountsPage> createState() => _MenuAccountsPageState();
}

class _MenuAccountsPageState extends State<MenuAccountsPage> {
  final int rowsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<IncomeCubit>().getAccount();
  }

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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.whiteColor,
        title: 'По счетам',
      ),
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Ошибка: }'));
          }
          if (state.accounts.isNotEmpty) {
            final transactions = state.accounts;

            // final totalBalance = transactions.fold<double>(
            //   0,
            //   (sum, item) => sum + (item.currentBalance ?? 0),
            // );

            if (transactions.isEmpty) {
              return const Center(child: Text('Нет транзакций'));
            }
            return _buildTableWithPagination(transactions, 0);
          }
          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildTableWithPagination(
    List<AccountModel> data,
    double totalBalance,
  ) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    // final pageCount = (data.length / rowsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('96 512 с', style: AppTextStyles.f24w600),
          // Text(
          //   '${totalBalance.toStringAsFixed(0)} с',
          //   style: AppTextStyles.f24w600,
          // ),
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
                    return DataRow(
                      cells: [
                        DataCell(Text(tx.id.toString())),
                        DataCell(Text(tx.name)),
                        DataCell(Text(tx.currentBalance?.toString() ?? '—')),
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
}
