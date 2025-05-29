import 'package:aps_mobile/src/core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryReportsPage extends StatelessWidget {
  const CategoryReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Отчеты по статьям',
        backgroundColor: AppColors.whiteColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            20.h,
            ButtonsRow(),
            20.h,
            MonthsTabs(),
            20.h,
            TitleSection(title: 'Основные статьи , доход'),
            20.h,
            PieChartSection(),
            20.h,
            LegendSection(),
            40.h,
            DataTableSection(),

            40.h,
            TitleSection(title: 'Основные статьи , расход'),
            20.h,
            PieChartSection(),
            20.h,
            LegendSection(),
            40.h,
            DataTableSection(),
          ],
        ),
      ),
    );
  }
}

// Виджет с кнопками
class ButtonsRow extends StatelessWidget {
  const ButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButtonWidget(text: 'Распечатать', onPressed: () {}),
        SizedBox(width: 12),
        OutlinedButtonWidget(text: 'Скачать в Excel', onPressed: () {}),
      ],
    );
  }
}

// Виджет с вкладками месяцев
class MonthsTabs extends StatelessWidget {
  const MonthsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Январь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Февраль',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Март',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Апрель',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Май',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Июнь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Июль',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Август',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Сентябрь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Октябрь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Ноябрь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
          20.w,
          Text(
            'Декабрь',
            style: AppTextStyles.f12w400.copyWith(color: AppColors.greyColor),
          ),
        ],
      ),
    );
  }
}

// Заголовок
class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.f16w500);
  }
}

// Заглушка для диаграммы

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.8,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: MediaQuery.of(context).size.width * 0.16,
          sections: _showingSections(context),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    const double value = 34;
    return [
      PieChartSectionData(
        color: Color(0xFF7B37B5),
        value: value,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.2,
      ),
      PieChartSectionData(
        color: Color(0xFFF219A2),
        value: value,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.2,
      ),
      PieChartSectionData(
        color: Color(0xFF156CB1),
        value: value,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.25,
      ),
      PieChartSectionData(
        color: Color(0xFFCCC9AA),
        value: 50,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.2,
      ),
      PieChartSectionData(
        color: Color(0xFF1EBF93),
        value: 50,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.2,
      ),
      PieChartSectionData(
        color: Color(0xFFFCA12C),
        value: value,
        title: '34%',
        radius: MediaQuery.of(context).size.width * 0.2,
      ),
    ];
  }
}

// Легенда
class LegendSection extends StatelessWidget {
  const LegendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        LegendItem(color: Color(0xFF7B37B5), text: 'Открытие ИП'),
        LegendItem(color: Color(0xFFF219A2), text: 'Открытие ОсОО'),
        LegendItem(color: Color(0xFF156CB1), text: 'Доход от продажи'),
        LegendItem(color: Color(0xFFCCC9AA), text: 'Гражданское дело'),
        LegendItem(color: Color(0xFF1EBF93), text: 'Инвестиции'),
        LegendItem(color: Color(0xFFFCA12C), text: 'Выручка'),
      ],
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

// Таблица с данными
class DataTableSection extends StatelessWidget {
  const DataTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    final int rowsPerPage = 5;
    int currentPage = 1;
    final List<Map<String, String>> data = List.generate(223, (index) {
      return {
        '№': '${index + 1}',
        'Статья дохода': 'Доход от продажи',
        'Сумма (сом)': '444544',
        'Процент': '34%',
      };
    });

    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

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
          DataColumn(label: Text('№')),
          DataColumn(label: Text('Статья дохода')),
          DataColumn(label: Text('Сумма (сом)')),
          DataColumn(label: Text('Процент')),
        ],
        rows:
            paginatedData.map((row) {
              return DataRow(
                cells: [
                  DataCell(Text(row['№']!)),
                  DataCell(Text(row['Статья дохода']!)),
                  DataCell(Text(row['Сумма (сом)']!)),
                  DataCell(Text(row['Процент']!)),
                ],
              );
            }).toList(),
      ),
    );
  }
}
