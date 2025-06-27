// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:aps_mobile/src/core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MetricsPage extends StatefulWidget {
  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  List<Map<String, dynamic>> yearlyData = [];

  @override
  void initState() {
    super.initState();
    final menuCubit = context.read<MenuCubit>();
    if (menuCubit.state is! MenuTransactionsWithAccountsSuccess) {
      menuCubit.getTransactionsWithAccounts();
    } else {
      _prepareData(
        (menuCubit.state as MenuTransactionsWithAccountsSuccess).transactions,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Показатели',
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocListener<MenuCubit, MenuState>(
        listener: (context, state) {
          if (state is MenuTransactionsWithAccountsSuccess) {
            _prepareData(state.transactions);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              20.h,
              Row(
                children: [
                  OutlinedButtonWidget(text: 'Транзакции', onPressed: () {}),
                  12.w,
                  OutlinedButtonWidget(
                    text: 'Скачать в Excel',
                    onPressed: () {
                      exportToExcel();
                    },
                  ),
                ],
              ),
              20.h,
              DropDownFormField(
                items: ['по годам'],
                label: 'Выберите период',
                value: 'по годам',
                onChanged: (value) {},
              ),
              40.h,
              Text(
                'Таблица доходов и расходов по годам',
                style: AppTextStyles.f16w500,
              ),
              20.h,
              _buildMetrics(),
              60.h,
              Text(
                'График доходов и расходов по годам',
                style: AppTextStyles.f16w500,
              ),
              30.h,
              _buildGraphic(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics() {
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
          DataColumn(label: Text('Год')),
          DataColumn(label: Text('Доход (KGZ)')),
          DataColumn(label: Text('Расход (KGZ)')),
          DataColumn(label: Text('Чистый доход (KGZ)')),
        ],
        rows:
            yearlyData.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['year'].toString())),
                  DataCell(
                    Text(
                      row['income'].toString(),
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['expense'].toString(),
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      row['balance'].toString(),
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.greenColor,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildGraphic() {
    const double barWidth = 170;
    const double groupSpacing = 20;

    final List<String> years =
        yearlyData.map((e) => e['year'].toString()).toList();
    final List<double> values =
        yearlyData.map((e) {
          final income =
              Decimal.tryParse(e['income'].toString()) ?? Decimal.zero;
          return income.toDouble(); // Или сумма с expense, если хочешь
        }).toList();

    final colors = [
      const Color(0xFF7B37B5),
      const Color(0xFFF219A2),
      const Color(0xFF156CB1),
      const Color(0xFFCCC9AA),
      const Color(0xFF1EBF93),
      const Color(0xFFFCA12C),
    ];

    double chartWidth =
        years.length * barWidth + (years.length - 1) * groupSpacing + 40;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: chartWidth,
        height: 400,
        child: BarChart(
          BarChartData(
            maxY:
                (values.isNotEmpty
                    ? values.reduce((a, b) => a > b ? a : b) * 1.2
                    : 1000),
            barGroups: List.generate(years.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: values[index],
                    color: colors[index % colors.length],
                    width: barWidth,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20000,
              getDrawingHorizontalLine:
                  (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index >= 0 && index < years.length) {
                      return Text(years[index]);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20000,
                  reservedSize: 70,
                  getTitlesWidget: (value, _) => Text(value.toInt().toString()),
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            groupsSpace: groupSpacing,
          ),
        ),
      ),
    );
  }

  void _prepareData(List<AllTransactionsModel> transactions) {
    final Map<String, Map<String, Decimal>> grouped = {};

    for (final tx in transactions) {
      final date = tx.date;
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final type = tx.transactionType;
      if (date == null || type == null) continue;

      final year = date.substring(0, 4);

      grouped.putIfAbsent(
        year,
        () => {'income': Decimal.zero, 'expense': Decimal.zero},
      );

      if (type == 'income') {
        grouped[year]!['income'] = grouped[year]!['income']! + amount;
      } else if (type == 'expense') {
        grouped[year]!['expense'] = grouped[year]!['expense']! + amount;
      }
    }

    final List<Map<String, dynamic>> result = [];
    grouped.forEach((year, data) {
      final income = data['income'] ?? Decimal.zero;
      final expense = data['expense'] ?? Decimal.zero;
      final balance = income - expense;

      result.add({
        'year': year,
        'income': income,
        'expense': expense,
        'balance': balance,
      });
    });

    setState(() {
      yearlyData = result;
    });
  }

  void exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Отчет'];

    // Заголовок
    sheet.appendRow([
      TextCellValue('Год'),
      TextCellValue('Доход (KGZ)'),
      TextCellValue('Расход (KGZ)'),
      TextCellValue('Чистый доход (KGZ)'),
    ]);

    // Данные
    for (final row in yearlyData) {
      sheet.appendRow([
        TextCellValue(row['year'].toString()),
        TextCellValue(row['income'].toString()),
        TextCellValue(row['expense'].toString()),
        TextCellValue(row['balance'].toString()),
      ]);
    }

    // Сохранение
    final fileBytes = excel.save();
    if (fileBytes == null) return;

    // Путь сохранения
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Отчет.xlsx');

    await file.writeAsBytes(fileBytes, flush: true);

    // iOS: готово
    // Android: желательно запросить разрешение на доступ
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Разрешение на запись не получено');
        return;
      }
    }

    // Уведомление (можно заменить SnackBar или что-то свое)
    print('Файл сохранен: ${file.path}');
  }
}
