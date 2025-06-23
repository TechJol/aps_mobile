import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    context.read<MenuCubit>().getAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Счета',
        backgroundColor: AppColors.backroundColor,
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
              return const Center(child: Text('Нет транзакций'));
            }
            return _buildTableSection(context, accounts);
          }
          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Column _buildTableSection(BuildContext context, List<AccountModel> account) {
    final hasAccount = account.isNotEmpty;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                20.h,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.addAccount);
                        },
                        label: const Text(
                          'Добавить счет',
                          style: AppTextStyles.f16w500,
                        ),
                        icon: const Icon(Icons.add, size: 20),
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorLight,
                          foregroundColor: Colors.white,
                          fixedSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ),
                  ],
                ),
                12.h,

                if (hasAccount)
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Скачать в Excel',
                      ),
                    ],
                  ),
                20.h,
              ],
            ),
          ),
        ),
        12.h,

        if (hasAccount)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DataTable(
              showCheckboxColumn: true,
              showBottomBorder: true,
              headingRowColor: WidgetStateProperty.all(Colors.black),
              headingTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              columns: const [
                DataColumn(
                  label: Text('Название', style: AppTextStyles.f16w500),
                ),
                DataColumn(
                  label: Text('Тип счета', style: AppTextStyles.f16w500),
                ),
                DataColumn(label: Text('')), // для меню с тремя точками
              ],
              rows:
                  account.map((account) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(account.name, style: AppTextStyles.f16w500),
                        ),
                        DataCell(
                          Text(
                            account.accountType,
                            style: AppTextStyles.f16w500,
                          ),
                        ),

                        DataCell(
                          PopupMenuWid(
                            context: context,
                            tapDelete: () {
                              ShowSheet().showDeleteDialog(
                                context,
                                accountName: account.name,

                                onConfirm: () {
                                  context.read<MenuCubit>().deleteAccount(
                                    account.id!,
                                  );
                                  Navigator.pop(context);
                                },
                                title: 'Удалить счет',
                              );
                            },
                            tapEdit: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.editAccount,
                                arguments: account,
                              );

                              if (result == true) {
                                context.read<MenuCubit>().getAccounts();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          )
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text('Нет cчетов', style: AppTextStyles.f16w500),
            ),
          ),
      ],
    );
  }
}
