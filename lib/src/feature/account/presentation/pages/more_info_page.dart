import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MoreInfoPage extends StatelessWidget {
  const MoreInfoPage({super.key, required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.account.moreInfo,
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('${t.account.errors}: ${state.message}'));
          }

          if (state is! MenuTransactionsWithAccountsSuccess) {
            context.read<MenuCubit>().getTransactionsWithAccounts();
            return const SizedBox.shrink();
          }

          final txAll = state.transactions;
          final txByAccount = txAll
              .where((t) => t.account == account.id)
              .toList();

          final summaries = _buildCurrencySummaries(txByAccount);
          final service = LocalService();

          final localeTag = Localizations.localeOf(context).toLanguageTag();
          final formatter = NumberFormat.currency(
            locale: localeTag,
            symbol: '',
            decimalDigits: 2,
          );

          final currencyOrder = ['KGS', 'USD', 'EUR', 'RUB'];
          final sortedKeys = summaries.keys.toList()
            ..sort((a, b) {
              final ia = currencyOrder.indexOf(a);
              final ib = currencyOrder.indexOf(b);
              if (ia != -1 && ib != -1) return ia.compareTo(ib);
              if (ia != -1) return -1;
              if (ib != -1) return 1;
              return a.compareTo(b);
            });

          String formatOriginal(Decimal value, String code) {
            final doubleVal = double.tryParse(value.toString()) ?? 0.0;
            return formatNumericAmountWithCurrency(
              doubleVal,
              code,
              formatter: formatter,
            );
          }

          String formatKgs(Decimal? value) {
            if (value == null) return '-';
            final doubleVal = double.tryParse(value.toString()) ?? 0.0;
            return formatNumericAmountWithCurrency(
              doubleVal,
              'KGS',
              formatter: formatter,
            );
          }

          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.backroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      OutlinedButtonWidget(
                        text: t.account.print,
                        onPressed: () {
                          final headers1 = [
                            t.account.currency,
                            t.account.totalSumIncome,
                            t.account.totalSumExpense,
                            t.account.currentBalance,
                            '${t.account.currentBalance} (KGS)',
                          ];
                          final rows1 = sortedKeys.map((code) {
                            final summary = summaries[code]!;
                            return [
                              code,
                              summary.income.toString(),
                              summary.expense.toString(),
                              summary.balance.toString(),
                              summary.balanceKgs?.toString() ?? '-',
                            ];
                          }).toList();

                          final headers2 = [
                            'ID',
                            t.account.date,
                            t.account.typeTransaction,
                            t.account.reason,
                          ];
                          final rows2 = txByAccount.map((tx) {
                            final date = tx.date != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.parse(tx.date!))
                                : '';

                            final type = (tx.transactionType == 'income')
                                ? t.account.income
                                : t.account.expense;
                            final reason = tx.description ?? '';
                            return ['${tx.id ?? ''}', date, type, reason];
                          }).toList();

                          service.printReportAsPdf(
                            context: context,
                            title:
                                '${t.account.allTransactionsWithAccount}: ${account.name}',
                            headers: headers1,
                            rows: [
                              ...rows1,
                              [],
                              [
                                '--- ${t.account.allTransactionsWithAccount} ${account.name} ---',
                              ],
                              headers2,
                              ...rows2,
                            ],
                          );
                        },
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        text: t.account.export,
                        onPressed: () {
                          final headers1 = [
                            t.account.currency,
                            t.account.totalSumIncome,
                            t.account.totalSumExpense,
                            t.account.currentBalance,
                            '${t.account.currentBalance} (KGS)',
                          ];
                          final rows1 = sortedKeys.map((code) {
                            final summary = summaries[code]!;
                            return [
                              code,
                              summary.income.toString(),
                              summary.expense.toString(),
                              summary.balance.toString(),
                              summary.balanceKgs?.toString() ?? '-',
                            ];
                          }).toList();

                          final headers2 = [
                            'ID',
                            t.account.date,
                            t.account.typeTransaction,
                            t.account.reason,
                          ];
                          final rows2 = txByAccount.map((tx) {
                            final date = tx.date != null
                                ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.parse(tx.date!))
                                : '';
                            final type = (tx.transactionType == 'income')
                                ? t.account.income
                                : t.account.expense;
                            final reason = tx.description ?? '';
                            return ['${tx.id ?? ''}', date, type, reason];
                          }).toList();

                          service.exportToExcelGeneric(
                            fileName:
                                '${t.account.account.account.title}_${account.name}',
                            headers: headers1,
                            rows: [
                              ...rows1,
                              [],
                              [
                                '--- ${t.account.allTransactionsWithAccount} ${account.name} ---',
                              ],
                              headers2,
                              ...rows2,
                            ],
                            context: context,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              20.h,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t.account.balanceAllSummary}:',
                      style: AppTextStyles.f16w500,
                    ),
                    12.h,
                    _BoxedTable(
                      headerBg: Colors.black,
                      headerFg: Colors.white,
                      headers: [
                        t.account.currency,
                        t.account.totalSumIncome,
                        t.account.totalSumExpense,
                        t.account.currentBalance,
                        '${t.account.currentBalance} (KGS)',
                      ],
                      rows: summaries.entries.map((entry) {
                        final code = entry.key;
                        final summary = entry.value;
                        return [
                          code,
                          formatOriginal(summary.income, code),
                          formatOriginal(summary.expense, code),
                          formatOriginal(summary.balance, code),
                          formatKgs(summary.balanceKgs),
                        ];
                      }).toList(),
                    ),
                    28.h,

                    Text(
                      '${t.account.allTransactionsWithAccount} ${account.name}',
                      style: AppTextStyles.f16w500,
                    ),
                    12.h,

                    _BoxedTable(
                      headerBg: Colors.black,
                      headerFg: Colors.white,
                      headers: [
                        'ID',
                        t.account.date,
                        t.account.typeTransaction,
                        t.account.reason,
                      ],
                      rows: txByAccount.map((tx) {
                        final date = tx.date != null
                            ? DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.parse(tx.date!))
                            : '';

                        final type = (tx.transactionType == 'income')
                            ? t.account.income
                            : t.account.expense;
                        final reason = tx.description ?? '';
                        return ['${tx.id ?? ''}', date, type, reason];
                      }).toList(),
                    ),
                  ],
                ),
              ),

              40.h,
            ],
          );
        },
      ),
    );
  }
}

Map<String, _CurrencySummary> _buildCurrencySummaries(
  List<AllTransactionsModel> transactions,
) {
  final map = <String, _CurrencySummary>{};

  for (final tx in transactions) {
    final code = (tx.currency ?? 'KGS').toUpperCase();
    final summary = map.putIfAbsent(code, () => _CurrencySummary());
    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
    final kgsRaw = Decimal.tryParse(tx.kgsCurrencyAmount ?? '');
    final kgsAmount = kgsRaw ?? (code == 'KGS' ? amount : Decimal.zero);

    if (tx.transactionType == 'income') {
      summary.income += amount;
      summary.incomeKgs += kgsAmount;
    } else if (tx.transactionType == 'expense') {
      summary.expense += amount;
      summary.expenseKgs += kgsAmount;
    }
  }

  for (final code in const ['KGS', 'USD', 'EUR', 'RUB']) {
    map.putIfAbsent(code, () => _CurrencySummary());
  }
  return map;
}

class _CurrencySummary {
  Decimal income = Decimal.zero;
  Decimal expense = Decimal.zero;
  Decimal incomeKgs = Decimal.zero;
  Decimal expenseKgs = Decimal.zero;

  Decimal get balance => income - expense;
  Decimal? get balanceKgs {
    if (incomeKgs == Decimal.zero && expenseKgs == Decimal.zero) {
      return null;
    }
    return incomeKgs - expenseKgs;
  }
}

class _BoxedTable extends StatelessWidget {
  const _BoxedTable({
    required this.headers,
    required this.rows,
    this.headerBg = const Color(0xFF6200EE),
    this.headerFg = Colors.white,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final Color headerBg;
  final Color headerFg;

  @override
  Widget build(BuildContext context) {
    final minWidth = MediaQuery.of(context).size.width - 40;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minWidth),
        child: Table(
          columnWidths: {
            for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            top: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
            left: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
            right: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
            bottom: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
            horizontalInside: const BorderSide(
              color: Color(0xFFE5E5EA),
              width: 1,
            ),
            verticalInside: const BorderSide(
              color: Color(0xFFE5E5EA),
              width: 1,
            ),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(color: headerBg),
              children: headers
                  .map(
                    (h) => Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      child: Text(
                        h,
                        style: AppTextStyles.f16w500.copyWith(color: headerFg),
                      ),
                    ),
                  )
                  .toList(),
            ),

            ...rows.map(
              (r) => TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children: r
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        child: Text(c, style: AppTextStyles.f16w500),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
