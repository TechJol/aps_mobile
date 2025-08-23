// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingAccountPage extends StatefulWidget {
  const SettingAccountPage({super.key});

  @override
  State<SettingAccountPage> createState() => _SettingAccountPageState();
}

class _SettingAccountPageState extends State<SettingAccountPage> {
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
            return _buildTableSection(context, state.accounts);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableSection(BuildContext context, List<AccountModel> accounts) {
    final hasAccounts = accounts.isNotEmpty;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Верхняя панель
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
                            Navigator.pushNamed(
                              context,
                              AppRoutes.addSettingAccount,
                            );
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
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  12.h,
                  if (hasAccounts)
                    Row(
                      children: [
                        OutlinedButtonWidget(
                          onPressed: () {
                            final headers = ['№', 'Название', 'Тип счета'];
                            final rows =
                                accounts.asMap().entries.map((entry) {
                                  final index = entry.key + 1;
                                  final acc = entry.value;
                                  return [
                                    '$index',
                                    acc.name,
                                    _getAccountTypeName(acc.accountType),
                                  ];
                                }).toList();

                            _localService.printReportAsPdf(
                              context: context,
                              title: 'Настройки счетов',
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
                                accounts.asMap().entries.map((entry) {
                                  final index = entry.key + 1;
                                  final acc = entry.value;
                                  return [
                                    '$index',
                                    acc.name,
                                    _getAccountTypeName(acc.accountType),
                                  ];
                                }).toList();

                            _localService.exportToExcelGeneric(
                              fileName: 'Настройки_счетов',
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

          // Таблица
          if (hasAccounts)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;

                  const menuW = 32.0; // узкая колонка под троеточие
                  const spacing = 12.0;
                  const margin = 12.0;
                  const minTypeW = 110.0;
                  const maxTypeW = 160.0;

                  // ширина колонки "Тип счета"
                  double typeW = maxW * 0.33;
                  if (typeW < minTypeW) typeW = minTypeW;
                  if (typeW > maxTypeW) typeW = maxTypeW;

                  // оставшееся — под "Название"
                  final nameW = maxW - menuW - typeW - margin * 2 - spacing * 2;

                  // компактные высоты строк
                  final isSmall = maxW < 360;
                  final headingH = isSmall ? 44.0 : 52.0;
                  final rowH = isSmall ? 44.0 : 52.0;

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
                        dataRowMinHeight: rowH,
                        dataRowMaxHeight: rowH,
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
                            label: Text(
                              'Название',
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Тип счета',
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          DataColumn(label: Text('')),
                        ],
                        rows:
                            accounts.map((acc) {
                              final nameText = cut(acc.name, 12);
                              final typeText = cut(
                                _getAccountTypeName(acc.accountType),
                                14,
                              );

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
                                                Navigator.pop(context);
                                              },
                                              title: 'Удалить счет',
                                            );
                                          },
                                          tapEdit: () async {
                                            final result =
                                                await Navigator.pushNamed(
                                                  context,
                                                  AppRoutes.editSettingAccount,
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
                child: Text('Нет счетов', style: AppTextStyles.f16w500),
              ),
            ),
          30.h,
        ],
      ),
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
