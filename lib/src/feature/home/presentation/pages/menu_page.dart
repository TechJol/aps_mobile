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
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: false,
        title: Text('Меню', style: AppTextStyles.f20w500),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 16,
              ),
            ),
          ),
        ),
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
          ),
          const SizedBox(height: 12),
          ExpandableMenuItem(
            icon: 'assets/icons/folder2.svg',
            title: 'Отчеты',
            expanded: isReportsExpanded,
            onTap: () => setState(() => isReportsExpanded = !isReportsExpanded),
            children: const ['Финансовый отчет', 'Графики'],
          ),
          const SizedBox(height: 12),
          ExpandableMenuItem(
            icon: 'assets/icons/setting.svg',
            title: 'Настройки',
            expanded: isSettingsExpanded,
            onTap:
                () => setState(() => isSettingsExpanded = !isSettingsExpanded),
            children: const ['Профиль', 'Безопасность'],
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
