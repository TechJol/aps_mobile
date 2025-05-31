import 'package:aps_mobile/src/feature/feature.dart';
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
                Navigator.pushNamed(context, AppRoutes.transactions);
              } else if (value == 'По контрагентам') {
                Navigator.pushNamed(context, AppRoutes.forCounterparties);
              } else if (value == 'По счетам') {
                Navigator.pushNamed(context, AppRoutes.menuAccounts);
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
                Navigator.pushNamed(context, AppRoutes.categoryReports);
              } else if (value == 'Общее положение доходов и расходов') {
                Navigator.pushNamed(context, AppRoutes.incomeExpenseSummary);
              } else if (value == 'Месячный отчет по доходам и расходам') {
                Navigator.pushNamed(context, AppRoutes.monthlyReport);
              } else if (value == 'Показатели') {
                Navigator.pushNamed(context, AppRoutes.metrics);
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
            onChildTap: (childTitle) {
              if (childTitle == 'Контрагенты') {
                Navigator.pushNamed(context, AppRoutes.counterparties);
              }
              if (childTitle == 'Тип контрагентов') {
                Navigator.pushNamed(context, AppRoutes.typeCounterparties);
              }
              if (childTitle == 'Счета') {
                Navigator.pushNamed(context, AppRoutes.settingAccount);
              }
              if (childTitle == 'Статьи') {
                Navigator.pushNamed(context, AppRoutes.articles);
              }
            },
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
