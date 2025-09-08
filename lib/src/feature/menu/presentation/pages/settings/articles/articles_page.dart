// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';

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
    // Тихий рефреш общих данных; причины придут вместе
    context.read<MenuCubit>().getTransactionsWithAccounts(force: true);
    // Можно дополнительно запросить причины, если нужно спец-состояние
    // context.read<MenuCubit>().getReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.articles.title,
        backgroundColor: AppColors.backroundColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MenuError) {
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }

          if (state is DeleteError) {
            final e = state.error;
            final msg =
                e is DioException
                    ? '${t.menu.error} [${e.response?.statusCode}]: ${e.response?.data ?? e.message}'
                    : '${t.menu.error}: $e';
            return Center(child: Text(msg));
          }

          if (state is MenuReasonsSuccess) {
            return _buildTableSection(context, state.reasons);
          }

          if (state is MenuTransactionsWithAccountsSuccess) {
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
                            Navigator.pushNamed(context, AppRoutes.addArticles);
                          },
                          label: Text(
                            t.menu.articles.addArticle,
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
                            final headers = [
                              '№',
                              t.menu.articles.name,
                              t.menu.articles.type,
                            ];
                            final rows =
                                reasons.asMap().entries.map((entry) {
                                  final i = entry.key + 1;
                                  final r = entry.value;
                                  return [
                                    '$i',
                                    r.name,
                                    r.type == 'income'
                                        ? t.menu.articles.income
                                        : t.menu.articles.expense,
                                  ];
                                }).toList();

                            _localService.printReportAsPdf(
                              context: context,
                              title: t.menu.articles.title,
                              headers: headers,
                              rows: rows,
                            );
                          },
                          text: t.menu.articles.print,
                        ),
                        12.w,
                        OutlinedButtonWidget(
                          onPressed: () {
                            final headers = [
                              '№',
                              t.menu.articles.name,
                              t.menu.articles.type,
                            ];
                            final rows =
                                reasons.asMap().entries.map((entry) {
                                  final i = entry.key + 1;
                                  final r = entry.value;
                                  return [
                                    '$i',
                                    r.name,
                                    r.type == 'income'
                                        ? t.menu.articles.income
                                        : t.menu.articles.expense,
                                  ];
                                }).toList();

                            _localService.exportToExcelGeneric(
                              fileName: t.menu.articles.title,
                              headers: headers,
                              rows: rows,
                              context: context,
                            );
                          },
                          text: t.menu.articles.export,
                        ),
                      ],
                    ),
                  20.h,
                ],
              ),
            ),
          ),
          12.h,

          if (hasReasons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;

                  const menuW = 32.0;
                  const spacing = 12.0;
                  const margin = 12.0;
                  const minTypeW = 100.0;
                  const maxTypeW = 140.0;

                  double typeW = maxW * 0.28;
                  if (typeW < minTypeW) typeW = minTypeW;
                  if (typeW > maxTypeW) typeW = maxTypeW;

                  final nameW = maxW - typeW - menuW - margin * 2 - spacing * 2;

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
                        columns: [
                          DataColumn(
                            label: Text(
                              t.menu.articles.name,
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              t.menu.articles.type,
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          const DataColumn(label: Text('')),
                        ],
                        rows:
                            reasons.map((r) {
                              final nameText = cut(r.name, 18);
                              final typeText =
                                  r.type == 'income'
                                      ? t.menu.articles.income
                                      : t.menu.articles.expense;

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
                                              title:
                                                  t.menu.articles.deleteArticle,
                                            );
                                          },
                                          tapEdit: () async {
                                            final res =
                                                await Navigator.pushNamed(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  t.menu.articles.notFound,
                  style: AppTextStyles.f16w500,
                ),
              ),
            ),
          30.h,
        ],
      ),
    );
  }
}
