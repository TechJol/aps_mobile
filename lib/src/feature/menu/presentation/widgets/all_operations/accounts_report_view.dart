import 'dart:math' as math;

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/menu/presentation/widgets/all_operations/account_report.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef AccountReportAction = void Function(List<List<String>> rows);

class AccountsReportView extends StatelessWidget {
  const AccountsReportView({
    super.key,
    required this.summary,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPageChanged,
    required this.onPrint,
    required this.onExport,
  });

  final AccountReportSummary summary;
  final int rowsPerPage;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final AccountReportAction onPrint;
  final AccountReportAction onExport;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rows = summary.rows;
    final pageCount = rows.isEmpty ? 0 : (rows.length / rowsPerPage).ceil();
    final pageIndex = pageCount == 0 ? 1 : currentPage.clamp(1, pageCount);
    final start = rows.isEmpty ? 0 : (pageIndex - 1) * rowsPerPage;
    final end = rows.isEmpty ? 0 : math.min(start + rowsPerPage, rows.length);
    final paginatedRows = rows.sublist(start, end);

    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '',
      decimalDigits: 2,
    );

    String formatAmount(Decimal value, String? currency) {
      final numeric = double.tryParse(value.toString()) ?? 0;
      return formatNumericAmountWithCurrency(
        numeric,
        currency,
        formatter: formatter,
      );
    }

    final reportRows = _buildReportRows(formatAmount);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rows.isNotEmpty) ...[
            Text(
              formatAmount(summary.totalKgs, 'KGS'),
              style: AppTextStyles.f24w600,
            ),
            Text(
              t.menu.accounts.total,
              style: AppTextStyles.f14w500.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ...summary.currencyTotals.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.currency,
                      style: AppTextStyles.f14w500.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      formatAmount(item.amount, item.currency),
                      style: AppTextStyles.f16w600,
                    ),
                  ],
                ),
              ),
            ),
            12.h,
            Row(
              children: [
                OutlinedButtonWidget(
                  text: t.menu.common.print,
                  onPressed: () => onPrint(reportRows),
                ),
                12.w,
                OutlinedButtonWidget(
                  text: t.menu.common.export,
                  onPressed: () => onExport(reportRows),
                ),
              ],
            ),
            20.h,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                border: TableBorder.all(
                  color: scheme.outlineVariant,
                  width: 1,
                ),
                columnWidths: const {
                  0: FixedColumnWidth(50),
                  1: FixedColumnWidth(200),
                  2: FixedColumnWidth(140),
                  3: FixedColumnWidth(120),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColorLight,
                    ),
                    children: [
                      _cell(
                        t.menu.common.numberSign,
                        context: context,
                        isHeader: true,
                      ),
                      _cell(
                        t.menu.accounts.headers.name,
                        context: context,
                        isHeader: true,
                      ),
                      _cell(
                        t.menu.accounts.headers.balance,
                        context: context,
                        isHeader: true,
                      ),
                      _cell(
                        t.menu.accounts.headers.accountType,
                        context: context,
                        isHeader: true,
                      ),
                    ],
                  ),
                  for (final row in paginatedRows)
                    TableRow(
                      children: [
                        _cell('${row.index}', context: context),
                        _cell(row.account.name, context: context),
                        _cell(
                          formatAmount(row.balance, row.account.currency),
                          context: context,
                        ),
                        _cell(
                          row.account.accountType == 'cash'
                              ? t.menu.accounts.type.cash
                              : t.menu.accounts.type.bank,
                          context: context,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Center(
                child: Text(t.menu.noData, style: AppTextStyles.f16w500),
              ),
            ),
          const SizedBox(height: 16),
          if (pageCount > 1)
            Center(
              child: _PaginationBar(
                pageCount: pageCount,
                currentPage: pageIndex,
                onPageChanged: onPageChanged,
              ),
            ),
        ],
      ),
    );
  }

  List<List<String>> _buildReportRows(
    String Function(Decimal value, String? currency) formatAmount,
  ) {
    return summary.rows
        .map(
          (row) => [
            '${row.index}',
            row.account.name,
            formatAmount(row.balance, row.account.currency),
            row.account.accountType == 'cash'
                ? t.menu.accounts.type.cash
                : t.menu.accounts.type.bank,
          ],
        )
        .toList();
  }

  static Widget _cell(
    String text, {
    required BuildContext context,
    bool isHeader = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            isHeader
                ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
                : AppTextStyles.f14w500.copyWith(color: scheme.onSurface),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.pageCount,
    required this.currentPage,
    required this.onPageChanged,
  });

  final int pageCount;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          ),
          for (int i = startPage; i <= endPage; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      i == currentPage ? AppColors.primaryColorLight : null,
                  foregroundColor:
                      i == currentPage ? Colors.white : scheme.onSurface,
                  side: BorderSide(color: scheme.outlineVariant),
                  minimumSize: const Size(36, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () => onPageChanged(i),
                child: Text('$i'),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                currentPage < pageCount
                    ? () => onPageChanged(currentPage + 1)
                    : null,
          ),
        ],
      ),
    );
  }
}
