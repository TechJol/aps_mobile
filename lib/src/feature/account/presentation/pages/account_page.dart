// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
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
        title: t.account.account.account.title,
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
            final accounts = state.accounts;
            return _buildTableSection(context, accounts);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Column _buildTableSection(BuildContext context, List<AccountModel> accounts) {
    final hasAccount = accounts.isNotEmpty;

    return Column(
      children: [
        // верхняя панель с кнопками
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        label: Text(
                          t.account.account.actions.addAccount,
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
                          final headers = [
                            '№',
                            t.account.name,
                            t.account.typeAccount,
                          ];
                          final rows =
                              accounts.asMap().entries.map<List<String>>((
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
                        text: t.account.print,
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = [
                            '№',
                            t.account.name,
                            t.account.typeAccount,
                          ];
                          final rows =
                              accounts.asMap().entries.map<List<String>>((
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
                        text: t.account.export,
                      ),
                    ],
                  ),
                20.h,
              ],
            ),
          ),
        ),
        12.h,

        // таблица
        if (hasAccount)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;

                const menuW = 32.0;
                const spacing = 12.0;
                const margin = 12.0;
                const minTypeW = 110.0;
                const maxTypeW = 180.0;

                double typeW = maxW * 0.33; // ширина колонки "Тип счета"
                if (typeW < minTypeW) typeW = minTypeW;
                if (typeW > maxTypeW) typeW = maxTypeW;

                // оставшееся пространство — под "Название"
                final nameW = maxW - menuW - typeW - margin * 2 - spacing * 2;

                final isSmall = maxW < 360;
                final headingH = isSmall ? 44.0 : 52.0;
                final rowMinH = isSmall ? 44.0 : 52.0;

                String typeName(String t) {
                  switch (t) {
                    case 'bank':
                      return 'Банк';
                    case 'cash':
                      return 'Касса';
                    default:
                      return 'Неизвестно';
                  }
                }

                String cut(String s, int max) =>
                    s.length > max ? '${s.substring(0, max)}…' : s;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DataTableTheme(
                    data: DataTableThemeData(
                      headingRowHeight: headingH,
                      dataRowMinHeight: rowMinH,
                      dataRowMaxHeight: rowMinH,
                      horizontalMargin: margin,
                    ),
                    child: DataTable(
                      showCheckboxColumn: false,
                      showBottomBorder: true,
                      columnSpacing: spacing,
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
                          label: Text(
                            'Тип счета',
                            style: AppTextStyles.f16w500,
                          ),
                        ),
                        DataColumn(label: Text('')), // колонка меню
                      ],
                      rows:
                          accounts.map((acc) {
                            final nameText = cut(acc.name, 18);
                            final typeText = cut(typeName(acc.accountType), 12);

                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: nameW,
                                    child: Text(
                                      nameText,
                                      style: AppTextStyles.f16w500,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: typeW,
                                    child: Text(
                                      typeText,
                                      style: AppTextStyles.f16w500,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: menuW,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuWid(
                                        context: context,
                                        tapDelete: () {
                                          ShowSheet().showDeleteDialog(
                                            context,
                                            accountName: acc.name,
                                            onConfirm: () {
                                              context
                                                  .read<MenuCubit>()
                                                  .deleteAccount(acc.id!);
                                              Navigator.pop(context, true);
                                            },
                                            title: 'Удалить счет',
                                          );
                                        },
                                        tapEdit: () async {
                                          final result =
                                              await Navigator.pushNamed(
                                                context,
                                                AppRoutes.editAccount,
                                                arguments: acc,
                                              );
                                          if (result == true) {
                                            context
                                                .read<MenuCubit>()
                                                .getAccounts();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
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
