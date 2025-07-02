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
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Меню',
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- Все операции ---
            ExpandableMenuItem(
              icon: 'assets/icons/folder1.svg',
              title: 'Все операции',
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
              children: const [
                'Все транзакции',
                'По контрагентам',
                'По счетам',
              ],
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

            // --- Отчёты ---
            ExpandableMenuItem(
              icon: 'assets/icons/folder2.svg',
              title: 'Отчеты',
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

            // --- Настройки ---
            ExpandableMenuItem(
              icon: 'assets/icons/setting.svg',
              title: 'Настройки',
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
              children: const [
                'Контрагенты',
                'Тип контрагентов',
                'Счета',
                'Статьи',
              ],
              onChildTap: (childTitle) async {
                if (childTitle == 'Контрагенты') {
                  await Navigator.pushNamed(context, AppRoutes.counterparties);
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                } else if (childTitle == 'Тип контрагентов') {
                  await Navigator.pushNamed(
                    context,
                    AppRoutes.typeCounterparties,
                  );
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                } else if (childTitle == 'Счета') {
                  await Navigator.pushNamed(context, AppRoutes.settingAccount);
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                } else if (childTitle == 'Статьи') {
                  await Navigator.pushNamed(context, AppRoutes.articles);
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                }
              },
            ),

            const SizedBox(height: 20),

            // --- Выход ---
            MenuItem(
              onTap: () {
                context.read<AuthCubit>().logout();
              },
              icon: 'assets/icons/folder3.svg',
              title: 'Выход',
            ),

            const SizedBox(height: 20),

            // --- Приветствие с именем пользователя ---
            BlocBuilder<CredentialCubit, CredentialState>(
              builder: (context, state) {
                if (state is CredentialUserLoaded) {
                  return MenuItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.profile);
                    },
                    icon: 'assets/icons/user.svg',
                    title: 'Привет, ${state.user.username}',
                  );
                } else {
                  return const Text('');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
