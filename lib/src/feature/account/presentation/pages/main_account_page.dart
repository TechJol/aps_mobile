import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAccountPage extends StatelessWidget {
  const MainAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Управление счетами',
            style: AppTextStyles.f24w600.copyWith(fontFamily: 'Inter'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.menu);
                },
                icon: Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<IncomeCubit, IncomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Ошибка: }'));
          }
          if (state.accounts.isNotEmpty) {
            final accounts = state.accounts;

            // final totalBalance = transactions.fold<double>(
            //   0,
            //   (sum, item) => sum + (item.currentBalance ?? 0),
            // );

            if (accounts.isEmpty) {
              return const Center(child: Text('Нет счетов'));
            }
            return _buildAccountSection(context, accounts);
          }
          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildAccountSection(BuildContext context, List<AccountModel> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'с',
                    style: AppTextStyles.f24w600.copyWith(fontFamily: 'Inter'),
                  ),
                  Text(
                    'общий баланс',
                    style: AppTextStyles.f14w500.copyWith(
                      color: AppColors.greyColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 48),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.account);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Добавить счет',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final account = data[index];
              final color =
                  index.isEven ? AppColors.redColor : AppColors.blueColor;

              return CardWidget(
                onTap: () {},
                price: ' c',
                office: account.name,
                cardColor: color,
              );
            },
          ),
        ],
      ),
    );
  }

  // String _calculateTotalBalance(List<AccountModel> accounts) {
  //   final total = accounts.fold<double>(
  //     0,
  //     (sum, acc) => sum + (acc.balance ?? 0),
  //   );
  //   return '${total.toStringAsFixed(0)} c';
  // }
}
