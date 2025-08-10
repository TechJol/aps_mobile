// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeCounterpartiesPage extends StatefulWidget {
  const TypeCounterpartiesPage({super.key});

  @override
  State<TypeCounterpartiesPage> createState() => _TypeCounterpartiesPageState();
}

class _TypeCounterpartiesPageState extends State<TypeCounterpartiesPage> {
  final LocalService _localService = LocalService();

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getPartnerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Типы контрагентов',
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

          if (state is MenuPartnerDataSuccess) {
            final types = state.partnerTypes ?? [];
            return _buildTableSection(context, types);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    List<PartnerTypesModel> types,
  ) {
    final hasTypes = types.isNotEmpty;

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
                          Navigator.pushNamed(context, AppRoutes.addType);
                        },
                        label: const Text(
                          'Добавить тип',
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
                if (hasTypes)
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = ['№', 'Название'];
                          final rows =
                              types.asMap().entries.map<List<String>>((entry) {
                                final index = entry.key + 1;
                                final type = entry.value;
                                return ['$index', type.name];
                              }).toList();

                          _localService.printReportAsPdf(
                            context: context,
                            title: 'Типы контрагентов',
                            headers: headers,
                            rows: rows,
                          );
                        },
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = ['№', 'Название'];
                          final rows =
                              types.asMap().entries.map<List<String>>((entry) {
                                final index = entry.key + 1;
                                final type = entry.value;
                                return ['$index', type.name];
                              }).toList();

                          _localService.exportToExcelGeneric(
                            fileName: 'Типы_контрагентов',
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

        // ----- Таблица: Название + узкая колонка меню -----
        if (hasTypes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;

                // компоновка без горизонтального скролла
                const menuW = 32.0; // колонка троеточия
                const spacing = 12.0;
                const margin = 12.0;

                // всё оставшееся — под «Название»
                final nameW = maxW - menuW - spacing - margin * 2;

                // компактные высоты на узких экранах
                final isSmall = maxW < 360;
                final headingH = isSmall ? 44.0 : 52.0;
                final rowH = isSmall ? 44.0 : 52.0;

                // ограничитель длины (дополнительно к ellipsis)
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
                      dataRowMaxHeight: rowH, // чтобы не было NOT NORMALIZED
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
                        DataColumn(label: Text('')), // меню
                      ],
                      rows:
                          types.map((type) {
                            final nameText = cut(
                              type.name,
                              18,
                            ); // максимум 18 символов

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
                                    width: menuW,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuWid(
                                        context: context,
                                        tapDelete: () {
                                          ShowSheet().showDeleteDialog(
                                            context,
                                            accountName: type.name,
                                            onConfirm: () {
                                              context
                                                  .read<MenuCubit>()
                                                  .deletePartnerType(type.id!);
                                              Navigator.pop(context);
                                            },
                                            title: 'Удалить тип',
                                          );
                                        },
                                        tapEdit: () async {
                                          final result =
                                              await Navigator.pushNamed(
                                                context,
                                                AppRoutes.editType,
                                                arguments: type,
                                              );
                                          if (result == true) {
                                            context
                                                .read<MenuCubit>()
                                                .getPartnerData();
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
              child: Text(
                'Нет типов контрагентов',
                style: AppTextStyles.f16w500,
              ),
            ),
          ),
      ],
    );
  }
}
