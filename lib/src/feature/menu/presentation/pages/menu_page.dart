// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  void initState() {
    context.read<CredentialCubit>().getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // локализованные подписи
    final opsTitle = t.menu.operations;
    final reportsTitle = t.menu.reports;
    final settingsTitle = t.menu.settings;

    final opsChildren = <String>[
      t.menu.operationsAll,
      t.menu.operationsByCounterparties,
      t.menu.operationsByAccounts,
    ];

    final reportsChildren = <String>[
      t.menu.metrics.yearlyReportTitle,
      t.menu.reportsByCounterparties,
      t.menu.otherReportsBuCounterparties,
      // t.menu.reportsMonthly,
      t.menu.reportsIncomeExpenseSummary,
      t.menu.reportsMetrics,
    ];

    final settingsChildren = <String>[
      t.menu.settingsCounterparties,
      t.menu.settingsCounterpartyTypes,
      t.menu.settingsAccounts,
      t.menu.settingsArticles,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: t.menu.menuTitle,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Полностью очищаем стек и переходим на логин
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- Все операции ---
            ExpandableMenuItem(
              icon: 'assets/icons/folder1.svg',
              title: opsTitle,
              expanded: isOperationsExpanded,
              onTap: () {
                setState(() {
                  isOperationsExpanded = !isOperationsExpanded;
                  if (isOperationsExpanded) {
                    isReportsExpanded = false;
                    isSettingsExpanded = false;
                  }
                });
              },
              children: opsChildren,
              onChildTap: (value) {
                if (value == t.menu.operationsAll) {
                  Navigator.pushNamed(context, AppRoutes.transactions);
                } else if (value == t.menu.operationsByCounterparties) {
                  Navigator.pushNamed(context, AppRoutes.forCounterparties);
                } else if (value == t.menu.operationsByAccounts) {
                  Navigator.pushNamed(context, AppRoutes.menuAccounts);
                }
              },
            ),

            12.h,

            // --- Отчёты ---
            ExpandableMenuItem(
              icon: 'assets/icons/folder2.svg',
              title: reportsTitle,
              expanded: isReportsExpanded,
              onTap: () {
                setState(() {
                  isReportsExpanded = !isReportsExpanded;
                  if (isReportsExpanded) {
                    isOperationsExpanded = false;
                    isSettingsExpanded = false;
                  }
                });
              },
              children: reportsChildren,
              onChildTap: (value) {
                if (value == t.menu.metrics.yearlyReportTitle) {
                  Navigator.pushNamed(context, AppRoutes.categoryReports);
                }
                if (value == t.menu.reportsByCounterparties) {
                  Navigator.pushNamed(context, AppRoutes.counterpartiesReports);
                }
                if (value == t.menu.otherReportsBuCounterparties) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detailCounterparitesReports,
                  );
                }
                // else if (value == t.menu.reportsMonthly) {
                //   Navigator.pushNamed(context, AppRoutes.monthlyReport);
                // }
                else if (value == t.menu.reportsIncomeExpenseSummary) {
                  Navigator.pushNamed(context, AppRoutes.incomeExpenseSummary);
                } else if (value == t.menu.reportsMetrics) {
                  Navigator.pushNamed(context, AppRoutes.metrics);
                }
              },
            ),

            12.h,

            // --- Настройки ---
            ExpandableMenuItem(
              icon: 'assets/icons/setting.svg',
              title: settingsTitle,
              expanded: isSettingsExpanded,
              onTap: () {
                setState(() {
                  isSettingsExpanded = !isSettingsExpanded;
                  if (isSettingsExpanded) {
                    isOperationsExpanded = false;
                    isReportsExpanded = false;
                  }
                });
              },
              children: settingsChildren,
              onChildTap: (childTitle) async {
                if (childTitle == t.menu.settingsCounterparties) {
                  await Navigator.pushNamed(context, AppRoutes.counterparties);
                  context.read<MenuCubit>().getTransactionsWithAccounts(
                    force: true,
                  );
                } else if (childTitle == t.menu.settingsCounterpartyTypes) {
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.typeCounterparties,
                  );
                  context.read<MenuCubit>().getTransactionsWithAccounts(
                    force: true,
                  );
                } else if (childTitle == t.menu.settingsAccounts) {
                  await Navigator.pushNamed(context, AppRoutes.settingAccount);
                  context.read<MenuCubit>().getTransactionsWithAccounts(
                    force: true,
                  );
                } else if (childTitle == t.menu.settingsArticles) {
                  await Navigator.pushNamed(context, AppRoutes.articles);
                  context.read<MenuCubit>().getTransactionsWithAccounts(
                    force: true,
                  );
                }
              },
            ),

            20.h,

            // --- Язык ---
            MenuItem(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.settingsApp);
              },
              icon: 'assets/icons/folder1.svg',
              title: t.menu.interface,
            ),

            20.h,

            // --- Выход ---
            MenuItem(
              onTap: () {
                context.read<AuthCubit>().logout();
              },
              icon: 'assets/icons/folder3.svg',
              title: t.menu.logout,
            ),

            20.h,

            // --- Профиль ---
            MenuItem(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              icon: 'assets/icons/user.svg',
              title: t.menu.profile.profile,
            ),
          ],
        ),
      ),
    );
  }
}
