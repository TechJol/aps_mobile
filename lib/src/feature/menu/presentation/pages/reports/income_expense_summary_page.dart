import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';

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
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuTransactionsWithAccountsSuccess) {
              final transactions = state.transactions;

              // Считаем данные по валютам (доходы, расходы и баланс)
              final Map<String, Map<String, Decimal>> aggregatedData = {};

              for (var tx in transactions) {
                final currency = tx.currency; // Получаем валюту
                final amount =
                    Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
                final type = tx.transactionType;

                if (!aggregatedData.containsKey(currency)) {
                  aggregatedData[currency!] = {
                    'income': Decimal.zero,
                    'expense': Decimal.zero,
                    'balance': Decimal.zero,
                    'rate': Decimal.zero, // Примерный курс валюты
                  };
                }

                // Проверка на null перед операцией сложения
                if (type == 'income') {
                  aggregatedData[currency]?['income'] =
                      (aggregatedData[currency]?['income'] ?? Decimal.zero) +
                      amount;
                } else if (type == 'expense') {
                  aggregatedData[currency]?['expense'] =
                      (aggregatedData[currency]?['expense'] ?? Decimal.zero) +
                      amount;
                }
              }

              // Вычисляем баланс по каждой валюте
              aggregatedData.forEach((currency, data) {
                data['balance'] = data['income']! - data['expense']!;
                if (currency == 'USD') {
                  data['rate'] = Decimal.parse('87.45');
                } else if (currency == 'EUR') {
                  data['rate'] = Decimal.parse('99.46');
                } else if (currency == 'RUB') {
                  data['rate'] = Decimal.parse('1.1');
                } else {
                  data['rate'] = Decimal.zero;
                }
              });

              final data =
                  aggregatedData.entries.map((entry) {
                    return {
                      'currency': entry.key,
                      'income': entry.value['income'].toString(),
                      'expense': entry.value['expense'].toString(),
                      'balance': entry.value['balance'].toString(),
                      'rate': entry.value['rate'].toString(),
                    };
                  }).toList();

              return ListView(children: [20.h, DataTableSectionA(data: data)]);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class DataTableSectionA extends StatelessWidget {
  final List<Map<String, String>> data;

  const DataTableSectionA({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
          DataColumn(label: Text('Валюта')),
          DataColumn(label: Text('Доходы')),
          DataColumn(label: Text('Расходы')),
          DataColumn(label: Text('Баланс')),
          DataColumn(label: Text('Баланс KGZ')),
          DataColumn(label: Text('Курс валюты')),
        ],
        rows:
            data.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['currency']!.toUpperCase())),
                  DataCell(Text(row['income']!)),
                  DataCell(Text(row['expense']!)),
                  DataCell(Text(row['balance']!)),
                  DataCell(Text(row['balance']!)),
                  DataCell(Text(row['rate']!)),
                ],
              );
            }).toList(),
      ),
    );
  }
}
