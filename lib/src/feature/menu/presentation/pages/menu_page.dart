import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/reports/category_reports_page.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/reports/income_expense_summary_page.dart';
import 'package:aps_mobile/src/feature/menu/presentation/pages/reports/monthly_report_page.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/src/core/core.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isOperationsExpanded = false;
  bool isReportsExpanded = false;
  bool isSettingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Меню',
        backgroundColor: AppColors.whiteColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ExpandableMenuItem(
            icon: 'assets/icons/folder1.svg',
            title: 'Все операции',
            expanded: isOperationsExpanded,
            onTap:
                () => setState(
                  () => isOperationsExpanded = !isOperationsExpanded,
                ),
            children: const ['Все транзакции', 'По контрагентам', 'По счетам'],
            onChildTap: (value) {
              if (value == 'Все транзакции') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionsPage()),
                );
              } else if (value == 'По контрагентам') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CounterpartiesPage()),
                );
              } else if (value == 'По счетам') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuAccountsPage()),
                );
              }
            },
          ),

          const SizedBox(height: 12),
          ExpandableMenuItem(
            icon: 'assets/icons/folder2.svg',
            title: 'Отчеты',
            expanded: isReportsExpanded,
            onTap: () => setState(() => isReportsExpanded = !isReportsExpanded),
            children: const [
              'Отчеты по статьям',
              'Общее положение доходов и расходов',
              'Месячный отчет по доходам и расходам',
              'Показатели',
            ],
            onChildTap: (value) {
              if (value == 'Отчеты по статьям') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CategoryReportsPage(),
                  ),
                );
              } else if (value == 'Общее положение доходов и расходов') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const IncomeExpenseSummaryPage(),
                  ),
                );
              } else if (value == 'Месячный отчет по доходам и расходам') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MonthlyReportPage()),
                );
              } else if (value == 'Показатели') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransactionsPage()),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          ExpandableMenuItem(
            icon: 'assets/icons/setting.svg',
            title: 'Настройки',
            expanded: isSettingsExpanded,
            onTap:
                () => setState(() => isSettingsExpanded = !isSettingsExpanded),
            children: const [
              'Контрагенты',
              'Тип контрагентов',
              'Счета',
              'Статьи',
            ],
          ),
          const SizedBox(height: 20),
          const MenuItem(icon: 'assets/icons/folder3.svg', title: 'Выход'),
          const SizedBox(height: 20),
          const MenuItem(icon: 'assets/icons/user.svg', title: 'Привет, Аяна'),
        ],
      ),
    );
  }
}
