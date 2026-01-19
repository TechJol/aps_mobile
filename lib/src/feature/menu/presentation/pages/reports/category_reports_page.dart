// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryReportsPage extends StatefulWidget {
  const CategoryReportsPage({super.key});

  @override
  _CategoryReportsPageState createState() => _CategoryReportsPageState();
}

class _CategoryReportsPageState extends State<CategoryReportsPage> {
  final LocalService _localService = LocalService();
  String selectedMonth = DateTime.now().month.toString();
  int selectedYear = DateTime.now().year;
  late final TextEditingController _yearController;
  final ScrollController _monthsController = ScrollController();

  static const String _kgs = 'KGS';

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: selectedYear.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final months = _localizedMonths();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.metrics.yearlyReportTitle,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuTransactionsWithAccountsSuccess) {
            final incomeData = _calculateTop6Reasons(
              state.transactions,
              state.reasons,
              type: 'income',
              month: selectedMonth,
              currency: _kgs,
              year: selectedYear,
            );

            final expenseData = _calculateTop6Reasons(
              state.transactions,
              state.reasons,
              type: 'expense',
              month: selectedMonth,
              currency: _kgs,
              year: selectedYear,
            );

            final hasIncomeData = incomeData.isNotEmpty;
            final hasExpenseData = expenseData.isNotEmpty;
            final yearTotals = _calculateYearTotals(
              state.transactions,
              year: selectedYear,
              currency: _kgs,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  20.h,
                  ButtonsRow(
                    onExport: () {
                      final sections = _buildYearlyReportSections(
                        transactions: state.transactions,
                        reasons: state.reasons,
                        year: selectedYear,
                        currency: _kgs,
                      );
                      _localService.exportToExcelSections(
                        fileName:
                            '${t.menu.reportsByArticle.filenamePrefix}$selectedYear',
                        sections: sections,
                        context: context,
                      );
                    },
                    onPrint: () {
                      final sections = _buildYearlyReportSections(
                        transactions: state.transactions,
                        reasons: state.reasons,
                        year: selectedYear,
                        currency: _kgs,
                      );
                      _localService.printReportAsPdfSections(
                        context: context,
                        title:
                            '${t.menu.reportsByArticle.filenamePrefix} $selectedYear',
                        sections: sections,
                      );
                    },
                  ),
                  20.h,
                  TitleSection(
                    title:
                        '${t.menu.reportsByCounterpartyDetail.titleYearReport}: $selectedYear',
                  ),
                  20.h,
                  Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(t.menu.reportsByArticle.yearLabel),
                      ),
                      8.w,
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _yearController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      12.w,
                      Expanded(
                        flex: 2,
                        child: ElevatedButtonWidget(
                          text: t.operation.show,
                          onPressed: () {
                            final parsed = int.tryParse(_yearController.text);
                            if (parsed == null) return;
                            setState(() => selectedYear = parsed);
                          },
                        ),
                      ),
                    ],
                  ),
                  // ElevatedButtonWidget(
                  //   text: t.operation.show,
                  //   onPressed: () {
                  //     final parsed = int.tryParse(_yearController.text);
                  //     if (parsed == null) return;
                  //     setState(() => selectedYear = parsed);
                  //   },
                  // ),
                  20.h,
                  Row(
                    children: [
                      HeaderBalanceContainer(
                        title: t.income.incomes,
                        amount: yearTotals.income,
                        bgColor: AppColors.greenColor50,
                      ),
                      8.w,
                      HeaderBalanceContainer(
                        title: t.income.expenses,
                        amount: yearTotals.expense,
                        bgColor: AppColors.redColor50,
                      ),
                      8.w,
                      HeaderBalanceContainer(
                        title: t.income.balance,
                        amount: yearTotals.balance,
                        bgColor: AppColors.primaryColorLight,
                      ),
                      8.w,
                    ],
                  ),
                  20.h,
                  MonthsTabs(
                    months: months,
                    selectedMonth: selectedMonth,
                    scrollController: _monthsController,
                    onMonthSelected: (month) {
                      setState(() => selectedMonth = month);
                    },
                  ),
                  20.h,

                  if (!hasIncomeData && !hasExpenseData)
                    Center(child: Text(t.menu.common.noDataForSelectedMonth))
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasIncomeData) ...[
                          const TitleSection(title: 'Основные статьи доходов'),
                          PieChartSection(data: incomeData),
                          20.h,
                          LegendSection(data: incomeData),
                          20.h,
                          ReportTableWidget(
                            title: '',
                            headers: [
                              t.menu.common.numberSign,
                              t
                                  .menu
                                  .reportsByCounterpartyDetail
                                  .sections
                                  .incomeNameCol,
                              t.menu.common.amountKgs,
                            ],
                            rows: _buildReportTableRows(incomeData),
                            columnWidths: const [56, 220, 120],
                          ),
                          40.h,
                        ],
                        if (hasExpenseData) ...[
                          const TitleSection(title: 'Основные статьи расходов'),
                          PieChartSection(data: expenseData),
                          20.h,
                          LegendSection(data: expenseData),
                          20.h,
                          ReportTableWidget(
                            title: '',
                            headers: [
                              t.menu.common.numberSign,
                              t
                                  .menu
                                  .reportsByCounterpartyDetail
                                  .sections
                                  .expenseNameCol,
                              t.menu.common.amountKgs,
                            ],
                            rows: _buildReportTableRows(expenseData),
                            columnWidths: const [56, 220, 120],
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Map<String, dynamic>> _calculateTop6Reasons(
    List<AllTransactionsModel> transactions,
    List<IncomeExpenseReasons> reasons, {
    required String type, // 'income' | 'expense'
    required String month, // '1'..'12'
    required String currency, //  'KGS'
    required int year,
  }) {
    final Map<int, Decimal> totalsByReason = {};

    for (final tx in transactions) {
      final txTypeOk = tx.transactionType == type;
      if (tx.date == null || tx.date!.isEmpty) continue;
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(tx.date!);
      } catch (_) {
        continue;
      }
      final txMonthOk = parsedDate.month.toString() == month;
      final txYearOk = parsedDate.year == year;
      final txCurrOk =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      final hasReason = tx.incomeExpenseReason != null;

      if (!(txTypeOk && txMonthOk && txYearOk && txCurrOk && hasReason)) {
        continue;
      }

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final val = (type == 'expense') ? amount.abs() : amount;

      totalsByReason[tx.incomeExpenseReason!] =
          (totalsByReason[tx.incomeExpenseReason!] ?? Decimal.zero) + val;
    }

    if (totalsByReason.isEmpty) return [];

    final top = totalsByReason.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top6 = top.take(6).toList();

    final Decimal top6Total = top6.fold(
      Decimal.zero,
      (acc, e) => acc + e.value,
    );
    if (top6Total == Decimal.zero) return [];

    return top6.map((entry) {
      final reason = reasons.firstWhere(
        (r) => r.id == entry.key,
        orElse: () => IncomeExpenseReasons(
          id: entry.key,
          name: t.menu.common.untitled,
          type: type,
          company: null,
        ),
      );

      final Decimal value = entry.value;
      final Decimal percent = Decimal.parse(
        ((value / top6Total) * Decimal.fromInt(100).toRational())
            .toDouble()
            .toStringAsFixed(2),
      );

      return {
        'name': reason.name,
        'amount': value.toString(),
        'percent': percent,
      };
    }).toList();
  }

  List<List<String>> _buildReportTableRows(List<Map<String, dynamic>> data) {
    return data.asMap().entries.map((entry) {
      final row = entry.value;
      return [
        '${entry.key + 1}',
        (row['name'] ?? '').toString(),
        (row['amount'] ?? '').toString(),
      ];
    }).toList();
  }

  _YearTotals _calculateYearTotals(
    List<AllTransactionsModel> transactions, {
    required int year,
    required String currency,
  }) {
    Decimal income = Decimal.zero;
    Decimal expense = Decimal.zero;

    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(tx.date!);
      } catch (_) {
        continue;
      }
      if (parsedDate.year != year) continue;

      final isKgs =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      if (!isKgs) continue;

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      if (tx.transactionType == 'income') {
        income += amount;
      } else if (tx.transactionType == 'expense') {
        expense += amount.abs();
      }
    }

    final balance = income - expense;
    return _YearTotals(
      income: formatNumericAmountWithCurrency(
        income.toDouble(),
        currency,
        showKgsSuffix: true,
      ),
      expense: formatNumericAmountWithCurrency(
        expense.toDouble(),
        currency,
        showKgsSuffix: true,
      ),
      balance: formatNumericAmountWithCurrency(
        balance.toDouble(),
        currency,
        showKgsSuffix: true,
      ),
    );
  }

  List<PdfTableSection> _buildYearlyReportSections({
    required List<AllTransactionsModel> transactions,
    required List<IncomeExpenseReasons> reasons,
    required int year,
    required String currency,
  }) {
    final totals = _calculateYearTotals(
      transactions,
      year: year,
      currency: currency,
    );

    final totalsSection = PdfTableSection(
      title: t.menu.reportsByCounterpartyDetail.titleYearReport,
      headers: [t.menu.common.title, t.menu.common.amountKgs],
      rows: [
        [t.income.incomes, totals.income],
        [t.income.expenses, totals.expense],
        [t.income.balance, totals.balance],
      ],
    );

    final monthHeaders = [
      t.menu.articles.name,
      ..._localizedMonthsShort(),
      t.menu.common.total,
    ];

    final incomeRows = _buildYearlyCategoryRows(
      transactions: transactions,
      reasons: reasons,
      type: 'income',
      year: year,
      currency: currency,
    );

    final expenseRows = _buildYearlyCategoryRows(
      transactions: transactions,
      reasons: reasons,
      type: 'expense',
      year: year,
      currency: currency,
    );

    final incomeSection = PdfTableSection(
      title: t.menu.reportsByCounterpartyDetail.sections.incomeTitle,
      headers: monthHeaders,
      rows: incomeRows,
    );

    final expenseSection = PdfTableSection(
      title: t.menu.reportsByCounterpartyDetail.sections.expenseTitle,
      headers: monthHeaders,
      rows: expenseRows,
    );

    final monthlyTotals = _buildMonthlyTotalsRows(
      transactions: transactions,
      year: year,
      currency: currency,
    );

    final chartSection = PdfTableSection(
      title: t.menu.reportsByArticle.chartTitle,
      headers: [t.menu.common.month, t.income.incomes, t.income.expenses],
      rows: monthlyTotals,
    );

    return [totalsSection, chartSection, incomeSection, expenseSection];
  }

  List<List<String>> _buildYearlyCategoryRows({
    required List<AllTransactionsModel> transactions,
    required List<IncomeExpenseReasons> reasons,
    required String type,
    required int year,
    required String currency,
  }) {
    final Map<int, List<Decimal>> monthlyByReason = {};

    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(tx.date!);
      } catch (_) {
        continue;
      }

      if (parsedDate.year != year) continue;
      if (tx.transactionType != type) continue;

      final isKgs =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      if (!isKgs) continue;
      if (tx.incomeExpenseReason == null) continue;

      final monthIndex = parsedDate.month - 1;
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final value = type == 'expense' ? amount.abs() : amount;

      monthlyByReason.putIfAbsent(
        tx.incomeExpenseReason!,
        () => List.filled(12, Decimal.zero),
      );
      final current = monthlyByReason[tx.incomeExpenseReason!];
      if (current != null) {
        current[monthIndex] = current[monthIndex] + value;
      }
    }

    final sortedReasons = monthlyByReason.keys.toList()..sort();
    return sortedReasons.map((reasonId) {
      final reason = reasons.firstWhere(
        (r) => r.id == reasonId,
        orElse: () => IncomeExpenseReasons(
          id: reasonId,
          name: t.menu.common.untitled,
          type: type,
          company: null,
        ),
      );
      final values = monthlyByReason[reasonId]!;
      final total = values.fold(Decimal.zero, (acc, v) => acc + v);
      return [
        reason.name,
        ...values.map((v) => v.toStringAsFixed(2)),
        total.toStringAsFixed(2),
      ];
    }).toList();
  }

  List<List<String>> _buildMonthlyTotalsRows({
    required List<AllTransactionsModel> transactions,
    required int year,
    required String currency,
  }) {
    final income = List<Decimal>.filled(12, Decimal.zero);
    final expense = List<Decimal>.filled(12, Decimal.zero);

    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(tx.date!);
      } catch (_) {
        continue;
      }
      if (parsedDate.year != year) continue;

      final isKgs =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      if (!isKgs) continue;

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final monthIndex = parsedDate.month - 1;

      if (tx.transactionType == 'income') {
        income[monthIndex] += amount;
      } else if (tx.transactionType == 'expense') {
        expense[monthIndex] += amount.abs();
      }
    }

    final months = _localizedMonthsShort();
    return List.generate(12, (i) {
      return [
        months[i],
        income[i].toStringAsFixed(2),
        expense[i].toStringAsFixed(2),
      ];
    });
  }

  String? _txCurrency(AllTransactionsModel tx) {
    return tx.currency ?? 'KGS';
  }

  List<String> _localizedMonths() => [
    t.menu.months.january,
    t.menu.months.february,
    t.menu.months.march,
    t.menu.months.april,
    t.menu.months.may,
    t.menu.months.june,
    t.menu.months.july,
    t.menu.months.august,
    t.menu.months.september,
    t.menu.months.october,
    t.menu.months.november,
    t.menu.months.december,
  ];

  List<String> _localizedMonthsShort() {
    return _localizedMonths().map((m) {
      final trimmed = m.trim();
      return trimmed.length <= 3 ? trimmed : trimmed.substring(0, 3);
    }).toList();
  }

  void _scrollToCurrentMonth() {
    if (!_monthsController.hasClients) return;
    final idx = DateTime.now().month - 1; // 0-based
    // Примерная ширина вкладки с отступами ~70
    final approxTabWidth = 70.0;
    final offset = (idx - 2) * approxTabWidth;
    final max = _monthsController.position.maxScrollExtent;
    _monthsController.jumpTo(offset.clamp(0.0, max));
  }
}

class _YearTotals {
  const _YearTotals({
    required this.income,
    required this.expense,
    required this.balance,
  });

  final String income;
  final String expense;
  final String balance;
}
