import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeExpenseSummaryPage extends StatelessWidget {
  const IncomeExpenseSummaryPage({super.key});

  Future<Map<String, double>> _loadRates() async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    final service = NbkrRatesService(dio);
    return service.fetchRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.incomeExpenseSummary.title,
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

              // Агрегация доходов/расходов по валютам
              final Map<String, Map<String, Decimal>> aggregated = {};

              for (final tx in transactions) {
                final currency = (tx.currency ?? 'KGS').toUpperCase();
                final amount =
                    Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
                final type = tx.transactionType;

                aggregated.putIfAbsent(
                  currency,
                  () => {'income': Decimal.zero, 'expense': Decimal.zero},
                );

                if (type == 'income') {
                  aggregated[currency]!['income'] =
                      (aggregated[currency]!['income'] ?? Decimal.zero) +
                      amount;
                } else if (type == 'expense') {
                  aggregated[currency]!['expense'] =
                      (aggregated[currency]!['expense'] ?? Decimal.zero) +
                      amount;
                }
              }

              if (aggregated.isEmpty) {
                return ListView(
                  children: [
                    20.h,
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          t.menu.noData,
                          style: AppTextStyles.f16w500,
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Тянем курсы и строим таблицу
              return FutureBuilder<Map<String, double>>(
                future: _loadRates(),
                builder: (context, snap) {
                  final loading =
                      snap.connectionState == ConnectionState.waiting;
                  final rates = (snap.data ?? const {'KGS': 1.0}).map(
                    (k, v) => MapEntry(k.toUpperCase(), v),
                  );

                  // Готовим данные для таблицы
                  final List<RowData> rows = [];
                  aggregated.forEach((cur, map) {
                    final income = map['income'] ?? Decimal.zero;
                    final expense = map['expense'] ?? Decimal.zero;
                    final balance = income - expense;

                    // курс за 1 ед. валюты -> Decimal
                    Decimal rateDec;
                    if (cur == 'KGS') {
                      rateDec = Decimal.zero; // для KGS показываем "-"
                    } else {
                      final r = rates[cur] ?? 0.0;
                      rateDec = Decimal.parse(r.toString());
                    }

                    // баланс в KGS
                    final balanceKgz =
                        (cur == 'KGS')
                            ? balance // <- для KGS показываем сам баланс
                            : (rateDec == Decimal.zero
                                ? null
                                : (balance * rateDec));

                    rows.add(
                      RowData(
                        currency: cur,
                        income: income,
                        expense: expense,
                        balance: balance,
                        rate: rateDec,
                        balanceKgz: balanceKgz,
                      ),
                    );
                  });

                  return ListView(
                    children: [
                      20.h,
                      if (loading)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Text(t.menu.incomeExpenseSummary.loadingRates),
                            ],
                          ),
                        ),
                      DataTableSectionA(rows: rows),
                    ],
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class RowData {
  final String currency;
  final Decimal income;
  final Decimal expense;
  final Decimal balance;
  final Decimal rate; // KGS -> 0 (чтобы выводить "-")
  final Decimal? balanceKgz; // null для KGS

  RowData({
    required this.currency,
    required this.income,
    required this.expense,
    required this.balance,
    required this.rate,
    required this.balanceKgz,
  });
}

class DataTableSectionA extends StatelessWidget {
  const DataTableSectionA({super.key, required this.rows});
  final List<RowData> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    const curW = 100.0;
    const incW = 140.0;
    const expW = 140.0;
    const balW = 140.0;
    const balKGZW = 160.0;
    const rateW = 120.0;

    const cellHPad = 16.0;
    const gridColor = Color(0xFFE6E6E6);

    final totalFixedW =
        curW + incW + expW + balW + balKGZW + rateW + cellHPad * 2 * 6;

    TableRow header() => TableRow(
      decoration: const BoxDecoration(color: AppColors.primaryColorLight),
      children: [
        _cell(
          t.menu.incomeExpenseSummary.currency,
          isHeader: true,
          width: curW,
        ),
        _cell(t.menu.incomeExpenseSummary.income, isHeader: true, width: incW),
        _cell(t.menu.incomeExpenseSummary.expense, isHeader: true, width: expW),
        _cell(t.menu.incomeExpenseSummary.balance, isHeader: true, width: balW),
        _cell(
          t.menu.incomeExpenseSummary.balanceKgz,
          isHeader: true,
          width: balKGZW,
        ),
        _cell(
          t.menu.incomeExpenseSummary.exchangeRate,
          isHeader: true,
          width: rateW,
        ),
      ],
    );

    List<TableRow> dataRows() =>
        rows.map((r) {
          return TableRow(
            children: [
              _cell(r.currency, width: curW),
              _cell(r.income.toString(), width: incW),
              _cell(r.expense.toString(), width: expW),
              _cell(r.balance.toString(), width: balW),
              _cell(r.balanceKgz?.toString() ?? '-', width: balKGZW),
              _cell(
                r.currency == 'KGS' ? '-' : r.rate.toString(),
                width: rateW,
              ),
            ],
          );
        }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;
        final tableMinWidth = totalFixedW < screenW ? screenW : totalFixedW;

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
              children: [header(), ...dataRows()],
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
