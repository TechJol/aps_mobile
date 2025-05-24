import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';

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
          _buildExpandableMenuItem(
            icon: Icons.folder_copy_outlined,
            title: 'Все операции',
            expanded: isOperationsExpanded,
            onTap:
                () => setState(
                  () => isOperationsExpanded = !isOperationsExpanded,
                ),
            children: const ['Все транзакции', 'По контрагентам', 'По счетам'],
          ),
          const SizedBox(height: 12),
          _buildExpandableMenuItem(
            icon: Icons.insert_chart_outlined,
            title: 'Отчеты',
            expanded: isReportsExpanded,
            onTap: () => setState(() => isReportsExpanded = !isReportsExpanded),
            children: const ['Финансовый отчет', 'Графики'],
          ),
          const SizedBox(height: 12),
          _buildExpandableMenuItem(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            expanded: isSettingsExpanded,
            onTap:
                () => setState(() => isSettingsExpanded = !isSettingsExpanded),
            children: const ['Профиль', 'Безопасность'],
          ),
          const SizedBox(height: 20),
          _buildMenuItem(icon: Icons.logout, title: 'Выход'),
          const SizedBox(height: 20),
          _buildMenuItem(icon: Icons.person_outline, title: 'Привет, Аяна'),
        ],
      ),
    );
  }

  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required bool expanded,
    required VoidCallback onTap,
    required List<String> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color:
                  expanded
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryColor),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: AppTextStyles.f16w500)),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (expanded)
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(left: 40, top: 8),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(child, style: AppTextStyles.f14w400),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text(title, style: AppTextStyles.f16w500),
        ],
      ),
    );
  }
}
