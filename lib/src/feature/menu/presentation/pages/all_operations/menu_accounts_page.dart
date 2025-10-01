import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MenuAccountsPage extends StatefulWidget {
  const MenuAccountsPage({super.key});

  @override
  State<MenuAccountsPage> createState() => _MenuAccountsPageState();
}

class _MenuAccountsPageState extends State<MenuAccountsPage> {
  final LocalService _localService = LocalService();
  late final Future<Map<String, double>> _ratesFuture;

  final int rowsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    final s = context.read<MenuCubit>().state;
    if (s is! MenuTransactionsWithAccountsSuccess) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
    }
    _ratesFuture = _loadRates();
  }

  Future<Map<String, double>> _loadRates() async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final service = NbkrRatesService(dio);
      final rates = await service.fetchRates();
      return rates.map((key, value) => MapEntry(key.toUpperCase(), value));
    } catch (_) {
      return const {'KGS': 1.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        backgroundColor: AppColors.whiteColor,
        title: t.menu.operationsByAccounts, // "По счетам"
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

            final totalsByCurrency = _calculateTotalsByCurrency(transactions);
            for (final account in accounts) {
              final code = (account.currency ?? 'KGS').toUpperCase();
              totalsByCurrency.putIfAbsent(code, () => Decimal.zero);
            }

            return FutureBuilder<Map<String, double>>(
              future: _ratesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rates = (snapshot.data ?? const {'KGS': 1.0}).map(
                  (key, value) => MapEntry(key.toUpperCase(), value),
                );

                final totalBalance = calculateTotalBalance(transactions, rates);

                return _buildTableWithPagination(
                  context,
                  accounts,
                  totalBalance,
                  transactions,
                  totalsByCurrency,
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableWithPagination(
    BuildContext context,
    List<AccountModel> data,
    Decimal total,
    List<AllTransactionsModel> transactions,
    Map<String, Decimal> totalsByCurrency, {
    bool isLoading = false,
  }) {
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    final hasData = paginatedData.isNotEmpty;

    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '',
      decimalDigits: 2,
    );

    String formatKgs(Decimal value) {
      final doubleVal = double.tryParse(value.toString()) ?? 0.0;
      return formatNumericAmountWithCurrency(
        doubleVal,
        'KGS',
        formatter: formatter,
      );
    }

    String formatOriginal(Decimal value, String? code) {
      final doubleVal = double.tryParse(value.toString()) ?? 0.0;
      return formatNumericAmountWithCurrency(
        doubleVal,
        code,
        formatter: formatter,
      );
    }

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
          cell(t.menu.common.numberSign, isHeader: true),
          cell(t.menu.accounts.headers.name, isHeader: true),
          cell(t.menu.accounts.headers.balance, isHeader: true),
          cell(t.menu.accounts.headers.accountType, isHeader: true),
        ],
      ),
    );

    // Данные
    for (int i = 0; i < paginatedData.length; i++) {
      final acc = paginatedData[i];
      final balance = calculateAccountBalanceOriginal(
        accountId: acc.id!,
        transactions: transactions,
      );
      tableRows.add(
        TableRow(
          children: [
            cell('${start + i + 1}'),
            cell(acc.name),
            cell(formatOriginal(balance, acc.currency)),
            cell(
              acc.accountType == 'cash'
                  ? t.menu.accounts.type.cash
                  : t.menu.accounts.type.bank,
            ),
          ],
        ),
      );
    }

    final pageCount = (data.length / rowsPerPage).ceil();
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // ✅ ВЕРТИКАЛЬНЫЙ СКРОЛЛ ДЛЯ ВСЕГО КОНТЕНТА
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasData) ...[
            Text(formatKgs(total), style: AppTextStyles.f24w600),
            Text(
              t.menu.accounts.total,
              style: AppTextStyles.f14w500.copyWith(color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            ..._buildCurrencyBreakdown(totalsByCurrency, formatter),
            12.h,
          ],
          20.h,
          if (hasData)
            Row(
              children: [
                OutlinedButtonWidget(
                  text: t.menu.common.print,
                  onPressed: () {
                    final headers = [
                      t.menu.common.numberSign,
                      t.menu.accounts.headers.name,
                      t.menu.accounts.headers.balance,
                      t.menu.accounts.headers.accountType,
                    ];
                    final rows =
                        data.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final acc = entry.value;
                          final balance = calculateAccountBalanceOriginal(
                            accountId: acc.id!,
                            transactions: transactions,
                          );
                          return [
                            '$index',
                            acc.name,
                            formatOriginal(balance, acc.currency),
                            acc.accountType == 'cash'
                                ? t.menu.accounts.type.cash
                                : t.menu.accounts.type.bank,
                          ];
                        }).toList();
                    _localService.printReportAsPdf(
                      context: context,
                      title: t.menu.accounts.printTitle,
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
                      t.menu.accounts.headers.name,
                      t.menu.accounts.headers.balance,
                      t.menu.accounts.headers.accountType,
                    ];
                    final rows =
                        data.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final acc = entry.value;
                          final balance = calculateAccountBalanceOriginal(
                            accountId: acc.id!,
                            transactions: transactions,
                          );
                          return [
                            '$index',
                            acc.name,
                            formatOriginal(balance, acc.currency),
                            acc.accountType == 'cash'
                                ? t.menu.accounts.type.cash
                                : t.menu.accounts.type.bank,
                          ];
                        }).toList();
                    _localService.exportToExcelGeneric(
                      fileName: t.menu.accounts.fileName,
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
            // Горизонтальный скролл только для таблицы
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(
                  color: const Color(0xFFE6E6E6),
                  width: 1,
                ),
                columnWidths: colW,
                children: tableRows,
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(t.menu.noData, style: AppTextStyles.f16w500),
              ),
            ),
          const SizedBox(height: 16),
          Center(child: _buildPagination(pageCount)),
        ],
      ),
    );
  }

  Widget _buildPagination(int pageCount) {
    if (pageCount <= 1) return const SizedBox.shrink();

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
          for (int i = startPage; i <= endPage; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      i == currentPage ? AppColors.primaryColorLight : null,
                  foregroundColor:
                      i == currentPage ? Colors.white : Colors.black,
                  minimumSize: const Size(36, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () => goToPage(i, pageCount),
                child: Text('$i'),
              ),
            ),
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

  void goToPage(int page, int pageCount) {
    if (page >= 1 && page <= pageCount) {
      setState(() => currentPage = page);
    }
  }

  Decimal calculateTotalBalance(
    List<AllTransactionsModel> transactions,
    Map<String, double> rates,
  ) {
    Decimal total = Decimal.zero;

    for (final tx in transactions) {
      final amount = _amountInKgs(tx, rates);
      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }

    return total;
  }

  Decimal calculateAccountBalanceOriginal({
    required int accountId,
    required List<AllTransactionsModel> transactions,
  }) {
    Decimal total = Decimal.zero;

    for (final tx in transactions) {
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

  Map<String, Decimal> _calculateTotalsByCurrency(
    List<AllTransactionsModel> transactions,
  ) {
    final Map<String, Decimal> totals = {'KGS': Decimal.zero};

    for (final tx in transactions) {
      final code = (tx.currency ?? 'KGS').toUpperCase();
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      totals.putIfAbsent(code, () => Decimal.zero);

      if (tx.transactionType == 'income') {
        totals[code] = totals[code]! + amount;
      } else if (tx.transactionType == 'expense') {
        totals[code] = totals[code]! - amount;
      }
    }

    return totals;
  }

  Decimal _amountInKgs(AllTransactionsModel tx, Map<String, double> rates) {
    final currency = (tx.currency ?? 'KGS').toUpperCase();
    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

    if (currency == 'KGS') {
      return amount;
    }

    final kgsAmountStr = tx.kgsCurrencyAmount;
    if (kgsAmountStr != null && kgsAmountStr.trim().isNotEmpty) {
      return Decimal.tryParse(kgsAmountStr) ?? amount;
    }

    final rate = rates[currency];
    if (rate == null || rate == 0) {
      return amount;
    }

    return amount * Decimal.parse(rate.toString());
  }
}

List<Widget> _buildCurrencyBreakdown(
  Map<String, Decimal> totalsByCurrency,
  NumberFormat formatter,
) {
  final order = ['KGS', 'USD', 'EUR', 'RUB'];
  final keys = totalsByCurrency.keys.toSet();
  keys.addAll(order);
  final sorted =
      keys.toList()..sort((a, b) {
        final ia = order.indexOf(a);
        final ib = order.indexOf(b);
        if (ia != -1 && ib != -1) return ia.compareTo(ib);
        if (ia != -1) return -1;
        if (ib != -1) return 1;
        return a.compareTo(b);
      });

  final widgets = <Widget>[];

  for (final code in sorted) {
    final amount = totalsByCurrency[code] ?? Decimal.zero;
    if (amount == Decimal.zero) continue;

    final doubleVal = double.tryParse(amount.toString()) ?? 0.0;
    final formatted = formatNumericAmountWithCurrency(
      doubleVal,
      code,
      formatter: formatter,
    );

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              code,
              style: AppTextStyles.f14w500.copyWith(color: AppColors.greyColor),
            ),
            Text(formatted, style: AppTextStyles.f16w600),
          ],
        ),
      ),
    );
  }

  return widgets;
}
