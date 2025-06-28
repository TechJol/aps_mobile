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
            final types = state.partnerTypes;
            return _buildTableSection(context, types!);
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

        if (hasTypes)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
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
                  DataColumn(label: Text('')),
                ],
                rows:
                    types.map((type) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                type.name,
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
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.editType,
                                    arguments: type,
                                  );

                                  if (result == true) {
                                    context.read<MenuCubit>().getPartnerData();
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
          )
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text('Нет контрагентов', style: AppTextStyles.f16w500),
            ),
          ),
      ],
    );
  }
}
