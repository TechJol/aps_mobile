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
    super.initState();
    context.read<MenuCubit>().getReasons();
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
            return Center(child: Text('Ошибка: ${state.message}'));
          }

          if (state is DeleteError) {
            final e = state.error;
            final msg =
                e is DioException
                    ? 'Ошибка удаления [${e.response?.statusCode}]: ${e.response?.data ?? e.message}'
                    : 'Ошибка при удалении: $e';
            return Center(child: Text(msg));
          }

          if (state is MenuReasonsSuccess) {
            return _buildTableSection(context, state.reasons);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    List<IncomeExpenseReasons> reasons,
  ) {
    final hasReasons = reasons.isNotEmpty;

    return Column(
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
                          Navigator.pushNamed(context, AppRoutes.addArticles);
                        },
                        label: const Text(
                          'Добавить статью',
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
                if (hasReasons)
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = ['№', 'Название', 'Тип'];
                          final rows =
                              reasons.asMap().entries.map((entry) {
                                final i = entry.key + 1;
                                final r = entry.value;
                                return [
                                  '$i',
                                  r.name,
                                  r.type == 'income' ? 'Доход' : 'Расход',
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
                          final headers = ['№', 'Название', 'Тип'];
                          final rows =
                              reasons.asMap().entries.map((entry) {
                                final i = entry.key + 1;
                                final r = entry.value;
                                return [
                                  '$i',
                                  r.name,
                                  r.type == 'income' ? 'Доход' : 'Расход',
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

        // Таблица: Название + Тип + узкая колонка меню (без горизонтального скролла)
        if (hasReasons)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;

                // параметры
                const menuW = 32.0; // троеточие
                const spacing = 12.0;
                const margin = 12.0;
                const minTypeW = 100.0;
                const maxTypeW = 140.0;

                // ширина "Тип"
                double typeW = maxW * 0.28;
                if (typeW < minTypeW) typeW = minTypeW;
                if (typeW > maxTypeW) typeW = maxTypeW;

                // остальное — "Название"
                final nameW = maxW - typeW - menuW - margin * 2 - spacing * 2;

                // компактные высоты
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
                          label: Text('Название', style: AppTextStyles.f16w500),
                        ),
                        DataColumn(
                          label: Text('Тип', style: AppTextStyles.f16w500),
                        ),
                        DataColumn(label: Text('')),
                      ],
                      rows:
                          reasons.map((r) {
                            final nameText = cut(r.name, 18);
                            final typeText =
                                r.type == 'income' ? 'Доход' : 'Расход';

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
                                            accountName: r.name,
                                            onConfirm: () {
                                              context
                                                  .read<MenuCubit>()
                                                  .deleteReason(r.id!);
                                              Navigator.pop(context);
                                            },
                                            title: 'Удалить статью',
                                          );
                                        },
                                        tapEdit: () async {
                                          final res = await Navigator.pushNamed(
                                            context,
                                            AppRoutes.editArticles,
                                            arguments: r,
                                          );
                                          if (res == true) {
                                            context
                                                .read<MenuCubit>()
                                                .getReasons();
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
              child: Text('Нет статей', style: AppTextStyles.f16w500),
            ),
          ),
      ],
    );
  }
}
