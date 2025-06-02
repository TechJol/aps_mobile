import 'package:aps_mobile/pie_chart_page.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScreen([
      HomePage(),
      PieChartPage(),
      SizedBox(),
      SizedBox(),
    ]);
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen(this.items, {super.key});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items[context.watch<MainCubit>().state],
      bottomNavigationBar: Container(
        color: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BottomNavigationBar(
          elevation: 1,
          backgroundColor: AppColors.whiteColor,
          selectedItemColor: AppColors.buttonColor,
          unselectedItemColor: AppColors.blackColor,
          selectedLabelStyle: const TextStyle(height: 2),
          unselectedLabelStyle: const TextStyle(height: 2),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: context.watch<MainCubit>().state,
          onTap: (index) {
            // context.read<MainCubit>().change(index);
            if (index == 1) {
              IncomePage().showIncomeBottomSheet(
                context: context,
                title: ' Приход',
              );
            } else if (index == 2) {
              IncomePage().showIncomeBottomSheet(
                context: context,
                title: 'Расход',
              );
            } else {
              context.read<MainCubit>().change(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter: ColorFilter.mode(
                  context.watch<MainCubit>().state == 0
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Счета',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/income.svg',
                colorFilter: ColorFilter.mode(
                  context.watch<MainCubit>().state == 1
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Доход',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/comeout.svg',
                colorFilter: ColorFilter.mode(
                  context.watch<MainCubit>().state == 2
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Расход',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/operation.svg',
                colorFilter: ColorFilter.mode(
                  context.watch<MainCubit>().state == 3
                      ? AppColors.buttonColor
                      : AppColors.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Операции',
            ),
          ],
        ),
      ),
    );
  }
}
