// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final LocalService _localService = LocalService();

  @override
  void initState() {
    context.read<MenuCubit>().getReasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Статьи',
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

          if (state is MenuReasonsSuccess) {
            final reasons = state.reasons;
            return _buildTableSection(context, reasons);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Column _buildTableSection(
    BuildContext context,
    List<IncomeExpenseReasons> reasons,
  ) {
    return Column(
      children: [
        // Верхняя панель с кнопками
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
                          Navigator.pushNamed(context, AppRoutes.addArticles);
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
                Row(
                  children: [
                    OutlinedButtonWidget(
                      onPressed: () {
                        final headers = ['№', 'Название', 'Тип счета'];
                        final rows =
                            reasons.asMap().entries.map<List<String>>((entry) {
                              final index = entry.key + 1;
                              final reason = entry.value;
                              return [
                                '$index',
                                reason.name,
                                reason.type == 'income' ? 'Доход' : 'Расход',
                              ];
                            }).toList();

                        _localService.printReportAsPdf(
                          context: context,
                          title: 'Список статей',
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
                            reasons.asMap().entries.map<List<String>>((entry) {
                              final index = entry.key + 1;
                              final reason = entry.value;
                              return [
                                '$index',
                                reason.name,
                                reason.type == 'income' ? 'Доход' : 'Расход',
                              ];
                            }).toList();

                        _localService.exportToExcelGeneric(
                          fileName: 'Список_статей',
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

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
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
                  reasons.map((reason) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              reason.name,
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              reason.type == 'income' ? 'Доход' : 'Расход',
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                        ),
                        DataCell(
                          Align(
                            alignment: Alignment.centerRight,
                            child: PopupMenuWid(
                              context: context,
                              tapDelete: () {
                                ShowSheet().showDeleteDialog(
                                  context,
                                  accountName: reason.name,
                                  onConfirm: () {
                                    context.read<MenuCubit>().deleteReason(
                                      reason.id!,
                                    );
                                    Navigator.pop(context);
                                  },
                                  title: 'Удалить счет',
                                );
                              },
                              tapEdit: () async {
                                final reasons = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.editArticles,
                                  arguments: reason,
                                );

                                if (reasons == true) {
                                  context.read<MenuCubit>().getReasons();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
