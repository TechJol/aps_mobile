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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: t.menu.incomeExpenseSummary.title,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    final balanceKgz = (cur == 'KGS')
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

    final headers = [
      t.menu.incomeExpenseSummary.currency,
      t.menu.incomeExpenseSummary.income,
      t.menu.incomeExpenseSummary.expense,
      t.menu.incomeExpenseSummary.balance,
      t.menu.incomeExpenseSummary.balanceKgz,
      t.menu.incomeExpenseSummary.exchangeRate,
    ];

    final tableRows = rows.map((r) {
      return [
        r.currency,
        r.income.toString(),
        r.expense.toString(),
        r.balance.toString(),
        r.balanceKgz?.toString() ?? '-',
        r.currency == 'KGS' ? '-' : r.rate.toString(),
      ];
    }).toList();

    return ReportTableWidget(
      headers: headers,
      rows: tableRows,
      columnWidths: const [100, 140, 140, 140, 160, 120],
    );
  }
}
