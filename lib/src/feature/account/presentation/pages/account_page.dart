// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final LocalService _localService = LocalService();

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Счета',
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message.toString()}'));
          }

          if (state is DeleteError) {
            String message;

            if (state.error is DioException) {
              final err = state.error as DioException;
              final status = err.response?.statusCode;
              final detail = err.response?.data?.toString() ?? err.message;
              message = 'Ошибка удаления [$status]: $detail';
            } else {
              message = 'Ошибка при удалении: ${state.error.toString()}';
            }

            return Center(child: Text(message));
          }

          if (state is MenuAccountsSuccess) {
            final account = state.accounts;
            return _buildTableSection(context, account);
          }

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
                        onPressed: () {
                          final headers = ['№', 'Название', 'Тип счета'];
                          final rows =
                              account.asMap().entries.map<List<String>>((
                                entry,
                              ) {
                                final index = entry.key + 1;
                                final item = entry.value;
                                return [
                                  '$index',
                                  item.name,
                                  _getAccountTypeName(item.accountType),
                                ];
                              }).toList();

                          _localService.printReportAsPdf(
                            context: context,
                            title: 'Список счетов',
                            headers: headers,
                            rows: rows,
                          );
                        },
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = ['№', 'Название', 'Тип счета'];
                          final rows =
                              account.asMap().entries.map<List<String>>((
                                entry,
                              ) {
                                final index = entry.key + 1;
                                final item = entry.value;
                                return [
                                  '$index',
                                  item.name,
                                  _getAccountTypeName(item.accountType),
                                ];
                              }).toList();

                          _localService.exportToExcelGeneric(
                            fileName: 'Список_счетов',
                            headers: headers,
                            rows: rows,
                            context: context,
                          );
                        },
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
                            _getAccountTypeName(account.accountType),
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
                                  Navigator.pop(context, true);
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

  // Utility function to convert account type to a more user-friendly name
  String _getAccountTypeName(String accountType) {
    switch (accountType) {
      case 'bank':
        return 'Банк';
      case 'cash':
        return 'Касса';
      default:
        return 'Неизвестно';
    }
  }
}
