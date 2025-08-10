// lib/src/feature/menu/presentation/pages/more_info_page.dart
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
        title: 'Подробная информация',
        backgroundColor: AppColors.backroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuError) {
              return Center(child: Text('Ошибка: ${state.message}'));
            }

            if (state is! MenuTransactionsWithAccountsSuccess) {
              // подстрахуемся: загрузим необходимые данные
              context.read<MenuCubit>().getTransactionsWithAccounts();
              return const SizedBox.shrink();
            }

            final txAll = state.transactions;
            final txByAccount =
                txAll.where((t) => t.account == account.id).toList();

            // агрегаты по выбранному счёту
            Decimal income = Decimal.zero;
            Decimal expense = Decimal.zero;

            for (final tx in txByAccount) {
              final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
              if (tx.transactionType == 'income') income += amount;
              if (tx.transactionType == 'expense') expense += amount;
            }
            final balance = income - expense;

            final currency =
                account.currency ??
                (txByAccount.isNotEmpty
                    ? (txByAccount.first.currency ?? 'KGS')
                    : 'KGS');

            final service = LocalService();

            return ListView(
              children: [
                20.h,
                // Кнопки
                Row(
                  children: [
                    OutlinedButtonWidget(
                      text: 'Распечатать',
                      onPressed: () {
                        final headers1 = [
                          'Валюта',
                          'Общая сумма доходов',
                          'Общая сумма расходов',
                          'Текущий баланс',
                        ];
                        final rows1 = [
                          [
                            currency,
                            income.toString(),
                            expense.toString(),
                            balance.toString(),
                          ],
                        ];

                        final headers2 = [
                          'ID',
                          'Дата',
                          'Тип транзакции',
                          'Причина',
                        ];
                        final rows2 =
                            txByAccount.map((t) {
                              final date =
                                  t.date != null
                                      ? DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(DateTime.parse(t.date!))
                                      : '';
                              final type =
                                  (t.transactionType == 'income')
                                      ? 'Приход'
                                      : 'Расход';
                              final reason = t.description ?? '';
                              return ['${t.id ?? ''}', date, type, reason];
                            }).toList();

                        service.printReportAsPdf(
                          context: context,
                          title: 'Все транзакции по счёту: ${account.name}',
                          headers: headers1,
                          rows: [
                            ...rows1,
                            [],
                            ['--- ВСЕ ТРАНЗАКЦИИ ПО СЧЁТУ ${account.name} ---'],
                            headers2,
                            ...rows2,
                          ],
                        );
                      },
                    ),
                    12.w,
                    OutlinedButtonWidget(
                      text: 'Скачать в Excel',
                      onPressed: () {
                        final headers1 = [
                          'Валюта',
                          'Общая сумма доходов',
                          'Общая сумма расходов',
                          'Текущий баланс',
                        ];
                        final rows1 = [
                          [
                            currency,
                            income.toString(),
                            expense.toString(),
                            balance.toString(),
                          ],
                        ];

                        final headers2 = [
                          'ID',
                          'Дата',
                          'Тип транзакции',
                          'Причина',
                        ];
                        final rows2 =
                            txByAccount.map((t) {
                              final date =
                                  t.date != null
                                      ? DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(DateTime.parse(t.date!))
                                      : '';
                              final type =
                                  (t.transactionType == 'income')
                                      ? 'Приход'
                                      : 'Расход';
                              final reason = t.description ?? '';
                              return ['${t.id ?? ''}', date, type, reason];
                            }).toList();

                        service.exportToExcelGeneric(
                          fileName: 'Счёт_${account.name}',
                          headers: headers1,
                          rows: [
                            ...rows1,
                            [],
                            ['--- ВСЕ ТРАНЗАКЦИИ ПО СЧЁТУ ${account.name} ---'],
                            headers2,
                            ...rows2,
                          ],
                          context: context,
                        );
                      },
                    ),
                  ],
                ),

                20.h,

                // Таблица №1 — сводка по счёту
                Text(
                  'Баланс и общие суммы ($currency):',
                  style: AppTextStyles.f16w500,
                ),
                12.h,
                _BoxedTable(
                  headerBg: Colors.black,
                  headerFg: Colors.white,
                  headers: const [
                    'Валюта',
                    'Общая сумма доходов',
                    'Общая сумма расходов',
                    'Текущий баланс',
                  ],
                  rows: [
                    [
                      currency,
                      income.toString(),
                      expense.toString(),
                      balance.toString(),
                    ],
                  ],
                ),

                28.h,

                // Таблица №2 — все транзакции
                Text(
                  'Все транзакции по счёту ${account.name}',
                  style: AppTextStyles.f16w500,
                ),
                12.h,
                _BoxedTable(
                  headerBg: Colors.black,
                  headerFg: Colors.white,
                  headers: const ['ID', 'Дата', 'Тип транзакции', 'Причина'],
                  rows:
                      txByAccount.map((t) {
                        final date =
                            t.date != null
                                ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(DateTime.parse(t.date!))
                                : '';
                        final type =
                            (t.transactionType == 'income')
                                ? 'Приход'
                                : 'Расход';
                        final reason = t.description ?? '';
                        return ['${t.id ?? ''}', date, type, reason];
                      }).toList(),
                ),

                40.h,
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Универсальная таблица с горизонтальными и вертикальными границами.
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
            // заголовок
            TableRow(
              decoration: BoxDecoration(color: headerBg),
              children:
                  headers
                      .map(
                        (h) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          child: Text(
                            h,
                            style: AppTextStyles.f16w500.copyWith(
                              color: headerFg,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            // строки
            ...rows.map(
              (r) => TableRow(
                decoration: const BoxDecoration(color: Colors.white),
                children:
                    r
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
