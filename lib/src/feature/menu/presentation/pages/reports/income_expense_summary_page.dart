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

              final hasData = data.isNotEmpty;

              return ListView(
                children: [
                  20.h,
                  if (hasData)
                    DataTableSectionA(data: data)
                  else
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text('Нет данных', style: AppTextStyles.f16w500),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class DataTableSectionA extends StatelessWidget {
  const DataTableSectionA({super.key, required this.data});
  final List<Map<String, String>> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    // фиксированные ширины колонок под сетку
    const curW = 100.0; // Валюта
    const incW = 140.0; // Доходы
    const expW = 140.0; // Расходы
    const balW = 140.0; // Баланс
    const balKGZW = 160.0; // Баланс KGZ
    const rateW = 120.0; // Курс валюты

    const cellHPad = 16.0;
    const gridColor = Color(0xFFE6E6E6);

    final totalFixedW =
        curW + incW + expW + balW + balKGZW + rateW + cellHPad * 2 * 6;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final tableMinWidth = totalFixedW < screenW ? screenW : totalFixedW;

        TableRow header() => TableRow(
          decoration: const BoxDecoration(color: AppColors.primaryColorLight),
          children: [
            _cell('Валюта', isHeader: true, width: curW),
            _cell('Доходы', isHeader: true, width: incW),
            _cell('Расходы', isHeader: true, width: expW),
            _cell('Баланс', isHeader: true, width: balW),
            _cell('Баланс KGZ', isHeader: true, width: balKGZW),
            _cell('Курс валюты', isHeader: true, width: rateW),
          ],
        );

        List<TableRow> rows() =>
            data.map((row) {
              // парсим строки в Decimal
              Decimal income =
                  Decimal.tryParse(row['income'] ?? '') ?? Decimal.zero;
              Decimal expense =
                  Decimal.tryParse(row['expense'] ?? '') ?? Decimal.zero;
              Decimal balance =
                  Decimal.tryParse(row['balance'] ?? '') ?? (income - expense);
              Decimal rate =
                  Decimal.tryParse(row['rate'] ?? '') ?? Decimal.zero;

              final balanceKgz =
                  (rate == Decimal.zero) ? null : (balance * rate);

              return TableRow(
                children: [
                  _cell((row['currency'] ?? '').toUpperCase(), width: curW),
                  _cell(income.toString(), width: incW),
                  _cell(expense.toString(), width: expW),
                  _cell(balance.toString(), width: balW),
                  _cell(balanceKgz?.toString() ?? '-', width: balKGZW),
                  _cell(
                    rate == Decimal.zero ? '-' : rate.toString(),
                    width: rateW,
                  ),
                ],
              );
            }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableMinWidth),
            child: Table(
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: const {
                0: FixedColumnWidth(curW),
                1: FixedColumnWidth(incW),
                2: FixedColumnWidth(expW),
                3: FixedColumnWidth(balW),
                4: FixedColumnWidth(balKGZW),
                5: FixedColumnWidth(rateW),
              },
              children: [header(), ...rows()],
            ),
          ),
        );
      },
    );
  }

  Widget _cell(String text, {required double width, bool isHeader = false}) {
    final style =
        isHeader
            ? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
            : AppTextStyles.f16w500;

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
