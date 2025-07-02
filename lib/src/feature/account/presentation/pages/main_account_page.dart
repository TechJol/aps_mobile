// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAccountPage extends StatefulWidget {
  const MainAccountPage({super.key});

  @override
  State<MainAccountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  @override
  void initState() {
    context.read<MenuCubit>().getTransactionsWithAccounts();
    super.initState();
  }

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
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.menu,
                  );

                  if (result == true) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          if (state is MenuTransactionsWithAccountsSuccess) {
            final transactions = state.transactions;
            final accounts = state.accounts;

            final totalBalance = calculateTotalBalance(transactions);

            return _buildAccountSection(
              context,
              accounts,
              totalBalance,
              transactions,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildAccountSection(
    BuildContext context,
    List<AccountModel> data,
    Decimal total,
    List<AllTransactionsModel> transactions,
  ) {
    final hasAccount = data.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasAccount)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$total с',
                      style: AppTextStyles.f24w600.copyWith(
                        fontFamily: 'Inter',
                      ),
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
                onPressed: () async {
                  await Navigator.pushNamed(context, AppRoutes.account);
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Добавить счет',
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.add, size: 20, color: AppColors.blackColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          if (hasAccount)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final account = data[index];
                final color =
                    index.isEven ? AppColors.redColor : AppColors.blueColor;
                final balance = calculateAccountBalance(
                  accountId: account.id!,
                  transactions: transactions,
                );

                return CardWidget(
                  onTap: () {
                    // переход в подробности счета
                  },
                  price: '$balance с',
                  office: account.name,
                  cardColor: color,
                  currency: account.currency,
                );
              },
            ),
        ],
      ),
    );
  }

  Decimal calculateTotalBalance(List<AllTransactionsModel> transactions) {
    Decimal total = Decimal.zero;

    for (var tx in transactions) {
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }

    return total;
  }

  Decimal calculateAccountBalance({
    required int accountId,
    required List<AllTransactionsModel> transactions,
  }) {
    Decimal total = Decimal.zero;

    for (var tx in transactions) {
      if (tx.account == accountId) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

        if (tx.transactionType == 'income') {
          total += amount;
        } else if (tx.transactionType == 'expense') {
          total -= amount;
        }
      }
    }

    return total;
  }
}
