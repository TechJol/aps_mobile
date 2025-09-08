// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(const [
      HomePage(),
      MainAccountPage(),
      SizedBox(),
      SizedBox(),
      OperationPage(),
    ]);
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen(this.items, {super.key});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    // ВАЖНО: создаём зависимость от TranslationProvider
    final locale = TranslationProvider.of(context).flutterLocale;

    final currentIndex = context.watch<MainCubit>().state;

    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BottomNavigationBar(
          key: ValueKey('bn_${locale.languageCode}'),
          elevation: 1,
          backgroundColor: AppColors.whiteColor,
          selectedItemColor: AppColors.buttonColor,
          unselectedItemColor: AppColors.blackColor,
          selectedLabelStyle: const TextStyle(height: 2),
          unselectedLabelStyle: const TextStyle(height: 2),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: currentIndex,
          onTap: (index) async {
            if (index == 2) {
              final result = await IncomePage().showIncomeBottomSheet(
                context: context,
                title: t.income.incomes,
                transactionType: 'income',
              );
              if (result == true) {
                context
                    .read<MenuCubit>()
                    .getTransactionsWithAccounts(force: true);
              }
            } else if (index == 3) {
              final result = await IncomePage().showIncomeBottomSheet(
                context: context,
                title: t.income.expenses,
                transactionType: 'expense',
              );
              if (result == true) {
                context
                    .read<MenuCubit>()
                    .getTransactionsWithAccounts(force: true);
              }
            } else {
              context.read<MainCubit>().change(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/main.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 0
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: t.home.home,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 1
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: t.account.account.account.title,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/income.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: t.income.incomes,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/comeout.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 3
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: t.income.expenses,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/operation.svg',
                colorFilter: ColorFilter.mode(
                  currentIndex == 4
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: t.operation.operation,
            ),
          ],
        ),
      ),
    );
  }
}
