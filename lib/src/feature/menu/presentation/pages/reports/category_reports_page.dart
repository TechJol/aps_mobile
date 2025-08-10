// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Отчеты по статьям',
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
            );

            final expenseData = _calculateTop6Reasons(
              state.transactions,
              state.reasons,
              type: 'expense',
              month: selectedMonth,
            );

            // Проверка наличия данных для дохода и расхода
            bool hasIncomeData = incomeData.isNotEmpty;
            bool hasExpenseData = expenseData.isNotEmpty;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  20.h,
                  ButtonsRow(
                    onExport: () {
                      final headers = ['№', 'Статья', 'Сумма (сом)', 'Процент'];

                      final incomeRows =
                          incomeData.asMap().entries.map((e) {
                            final row = e.value;
                            return [
                              '${e.key + 1}',
                              '${row['name'] ?? ''}',
                              '${row['amount'] ?? ''}',
                              '${row['percent'] ?? ''}%',
                            ];
                          }).toList();

                      final expenseRows =
                          expenseData.asMap().entries.map((e) {
                            final row = e.value;
                            return [
                              '${e.key + 1}',
                              '${row['name'] ?? ''}',
                              '${row['amount'] ?? ''}',
                              '${row['percent'] ?? ''}%',
                            ];
                          }).toList();

                      _localService.exportToExcelGeneric(
                        fileName: 'Отчет_по_статьям_месяц_$selectedMonth',
                        headers: headers,
                        rows: [
                          ['--- ДОХОД ---'],
                          ...incomeRows,
                          [],
                          ['--- РАСХОД ---'],
                          ...expenseRows,
                        ],
                        context: context,
                      );
                    },
                    onPrint: () {
                      final headers = ['№', 'Статья', 'Сумма (сом)', 'Процент'];

                      final incomeRows =
                          incomeData.asMap().entries.map((e) {
                            final row = e.value;
                            return [
                              '${e.key + 1}',
                              '${row['name'] ?? ''}',
                              '${row['amount'] ?? ''}',
                              '${row['percent'] ?? ''}%',
                            ];
                          }).toList();

                      final expenseRows =
                          expenseData.asMap().entries.map((e) {
                            final row = e.value;
                            return [
                              '${e.key + 1}',
                              '${row['name'] ?? ''}',
                              '${row['amount'] ?? ''}',
                              '${row['percent'] ?? ''}%',
                            ];
                          }).toList();

                      _localService.printReportAsPdf(
                        context: context,
                        title: 'Отчет по статьям (месяц $selectedMonth)',
                        headers: headers,
                        rows: [
                          ['--- ДОХОД ---'],
                          ...incomeRows,
                          [],
                          ['--- РАСХОД ---'],
                          ...expenseRows,
                        ],
                      );
                    },
                  ),

                  20.h,
                  MonthsTabs(
                    selectedMonth: selectedMonth,
                    onMonthSelected: (month) {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                  ),
                  20.h,

                  if (!hasIncomeData && !hasExpenseData)
                    const Center(child: Text("Нет данных за выбранный месяц"))
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- ДОХОД ---
                        if (hasIncomeData) ...[
                          const TitleSection(title: 'Основные статьи , доход'),
                          PieChartSection(data: incomeData),
                          20.h,
                          LegendSection(data: incomeData),
                          20.h,
                          DataTableSection(data: incomeData),
                          40.h,
                        ],

                        // --- РАСХОД ---
                        if (hasExpenseData) ...[
                          const TitleSection(title: 'Основные статьи , расход'),
                          PieChartSection(data: expenseData),
                          20.h,
                          LegendSection(data: expenseData),
                          20.h,
                          DataTableSection(data: expenseData),
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
    required String type,
    required String month,
  }) {
    final Map<String, Map<int, Decimal>> monthlyTotals = {};

    for (var tx in transactions) {
      if (tx.transactionType == type && tx.incomeExpenseReason != null) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
        final txMonth = DateTime.parse(tx.date!).month.toString();

        if (txMonth == month) {
          if (!monthlyTotals.containsKey(month)) {
            monthlyTotals[month] = {};
          }

          monthlyTotals[month]?[tx.incomeExpenseReason!] =
              (monthlyTotals[month]?[tx.incomeExpenseReason!] ?? Decimal.zero) +
              amount;
        }
      }
    }

    // Если нет данных, возвращаем пустой список
    if (monthlyTotals.isEmpty || monthlyTotals[month] == null) {
      return [];
    }

    final sortedMonths = monthlyTotals.keys.toList()..sort();

    return sortedMonths.expand((month) {
      final monthlyData = monthlyTotals[month]!;
      Decimal totalAmount = Decimal.zero;

      monthlyData.forEach((key, value) {
        totalAmount += value;
      });

      final sorted =
          monthlyData.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      return sorted.take(6).map((entry) {
        final reason = reasons.firstWhere(
          (r) => r.id == entry.key,
          orElse:
              () => IncomeExpenseReasons(
                id: entry.key,
                name: 'Без названия',
                type: type,
                company: null,
              ),
        );

        final Decimal value = entry.value;
        final Decimal percent = Decimal.parse(
          ((value / totalAmount) * Decimal.fromInt(100).toRational())
              .toDouble()
              .toStringAsFixed(2),
        );

        return {
          'month': month,
          'name': reason.name,
          'amount': type == 'expense' ? (-value).toString() : value.toString(),
          'percent': percent,
        };
      }).toList();
    }).toList();
  }
}

class MonthsTabs extends StatelessWidget {
  const MonthsTabs({
    super.key,
    required this.onMonthSelected,
    required this.selectedMonth,
  });

  final Function(String) onMonthSelected;
  final String selectedMonth;

  @override
  Widget build(BuildContext context) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            months.asMap().entries.map((entry) {
              String monthNumber = (entry.key + 1).toString();
              bool isSelected = monthNumber == selectedMonth;

              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => onMonthSelected(monthNumber),
                  child: Text(
                    entry.value,
                    style: AppTextStyles.f12w400.copyWith(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.greyColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class ButtonsRow extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onPrint;
  const ButtonsRow({super.key, required this.onExport, required this.onPrint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButtonWidget(text: 'Распечатать', onPressed: onPrint),
        SizedBox(width: 12),
        OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: onExport),
      ],
    );
  }
}

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: w * 0.8,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          // пончик
          centerSpaceRadius: w * 0.16,
          sections:
              data.asMap().entries.map((entry) {
                final color = _chartColors[entry.key % _chartColors.length];
                final percent = (entry.value['percent'] as Decimal).toDouble();

                return PieChartSectionData(
                  color: color,
                  value: percent,
                  // как в макете: целые проценты, белым внутри сектора
                  title: '${percent.round()}%',
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  // позиция текста ближе к центру сектора
                  titlePositionPercentageOffset: 0.6,
                  radius: w * 0.2,
                );
              }).toList(),
        ),
      ),
    );
  }
}

class LegendSection extends StatelessWidget {
  const LegendSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          data.asMap().entries.map((entry) {
            final color = _chartColors[entry.key % _chartColors.length];
            return LegendItem(color: color, text: entry.value['name']);
          }).toList(),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 16, height: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: AppTextStyles.f14w500),
        ],
      ),
    );
  }
}

class DataTableSection extends StatelessWidget {
  const DataTableSection({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final textStyle = AppTextStyles.f16w500;

    // измеряем самую длинную "Статью"
    double measureTextWidth(String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout(minWidth: 0, maxWidth: double.infinity);
      return tp.width;
    }

    // базовые настройки ширин и отступов
    const numColW = 56.0; // №
    const sumColW = 140.0; // Сумма (сом)
    const pctColW = 110.0; // Процент
    const cellHPad = 16.0; // горизонтальный паддинг в ячейке
    const cellVPad = 14.0; // вертикальный паддинг в ячейке
    const gridColor = Color(0xFFE6E6E6);

    // максимальная ширина текста в "Статья"
    final maxNameTextW = data.fold<double>(80.0, (maxW, row) {
      final name = (row['name'] ?? '').toString();
      final w = measureTextWidth(name);
      return w > maxW ? w : maxW;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenW = constraints.maxWidth;

        // фиксированная часть (кроме колонки "Статья") + паддинги 4х колонок
        final fixedPartW = numColW + sumColW + pctColW + (cellHPad * 2 * 4);

        // если этого мало — растянем таблицу на весь экран,
        // если не помещается — дадим ей нужную minWidth и включим горизонтальный скролл
        final requiredTableW = fixedPartW + maxNameTextW;
        final tableMinWidth =
            requiredTableW < screenW ? screenW : requiredTableW;

        // ширина "Статья", когда таблица растянута и без скролла
        final nameColW = (screenW - fixedPartW).clamp(120.0, 800.0);

        // заголовок таблицы
        TableRow headerRow() => TableRow(
          decoration: const BoxDecoration(color: AppColors.primaryColorLight),
          children: [
            _cell(
              '№',
              isHeader: true,
              width: numColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              'Статья дохода',
              isHeader: true,
              width: tableMinWidth == screenW ? nameColW : maxNameTextW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              'Сумма (сом)',
              isHeader: true,
              width: sumColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
            _cell(
              'Процент',
              isHeader: true,
              width: pctColW,
              padH: cellHPad,
              padV: cellVPad,
            ),
          ],
        );

        // строки данных
        List<TableRow> dataRows() =>
            data.asMap().entries.map((entry) {
              final i = entry.key + 1;
              final row = entry.value;
              final name = (row['name'] ?? '').toString();
              final amount = (row['amount'] ?? '').toString();
              final percent = row['percent'];

              final isStretched = tableMinWidth == screenW;

              return TableRow(
                children: [
                  _cell('$i', width: numColW, padH: cellHPad, padV: cellVPad),
                  _cell(
                    name,
                    width: isStretched ? nameColW : maxNameTextW,
                    padH: cellHPad,
                    padV: cellVPad,
                    ellipsis: isStretched, // при растяжке режем длинные
                  ),
                  _cell(amount, width: sumColW, padH: cellHPad, padV: cellVPad),
                  _cell(
                    percent is Decimal
                        ? '${percent.toString()}%'
                        : '${percent ?? 0}%',
                    width: pctColW,
                    padH: cellHPad,
                    padV: cellVPad,
                  ),
                ],
              );
            }).toList();

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: tableMinWidth),
            child: Table(
              // полноценная сетка как в макете
              border: TableBorder.all(color: gridColor, width: 1),
              columnWidths: {
                0: const FixedColumnWidth(numColW),
                1: FixedColumnWidth(
                  tableMinWidth == screenW ? nameColW : maxNameTextW,
                ),
                2: const FixedColumnWidth(sumColW),
                3: const FixedColumnWidth(pctColW),
              },
              children: [headerRow(), ...dataRows()],
            ),
          ),
        );
      },
    );
  }

  // ячейка таблицы
  Widget _cell(
    String text, {
    required double width,
    required double padH,
    required double padV,
    bool isHeader = false,
    bool ellipsis = false,
  }) {
    final style =
        isHeader
            ? const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
            : AppTextStyles.f16w500;

    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: ellipsis ? TextOverflow.ellipsis : TextOverflow.visible,
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.f16w500);
  }
}

const List<Color> _chartColors = [
  Color(0xFF7B37B5),
  Color(0xFFF219A2),
  Color(0xFF156CB1),
  Color(0xFFCCC9AA),
  Color(0xFF1EBF93),
  Color(0xFFFCA12C),
];
