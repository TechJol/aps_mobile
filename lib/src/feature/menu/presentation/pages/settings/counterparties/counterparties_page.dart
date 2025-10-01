// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterpartiesPage extends StatefulWidget {
  const CounterpartiesPage({super.key});

  @override
  State<CounterpartiesPage> createState() => _CounterpartiesPageState();
}

class _CounterpartiesPageState extends State<CounterpartiesPage> {
  final LocalService _localService = LocalService();

  @override
  void initState() {
    super.initState();
    // Всегда обновляем данные тихо при входе на экран
    context.read<MenuCubit>().getTransactionsWithAccounts(force: true);
    // И параллельно обеспечим нужное состояние для экрана
    context.read<MenuCubit>().getPartnerData(force: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.counterparties.title,
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
            final error = state.error;
            final message =
                error is DioException
                    ? '${t.menu.error} [${error.response?.statusCode}]: ${error.response?.data ?? error.message}'
                    : '${t.menu.error}: $error';
            return Center(child: Text(message));
          }

          if (state is MenuPartnerDataSuccess) {
            return _buildTableSection(
              context,
              state.partners!,
              state.partnerTypes!,
            );
          }

          // Дополнительно поддерживаем общий успех
          if (state is MenuTransactionsWithAccountsSuccess) {
            return _buildTableSection(
              context,
              state.partners,
              state.partnerTypes ?? [],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    List<PartnersModel> partners,
    List<PartnerTypesModel> types,
  ) {
    String getTypeName(int typeId) {
      return types
          .firstWhere(
            (t) => t.id == typeId,
            orElse: () => PartnerTypesModel(id: typeId, name: t.menu.error),
          )
          .name;
    }

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              AppRoutes.addCounterparties,
                            );
                          },
                          label: Text(
                            t.menu.counterparties.addCounterparty,
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
                  if (partners.isNotEmpty)
                    Row(
                      children: [
                        OutlinedButtonWidget(
                          onPressed: () {
                            final headers = [
                              '№',
                              t.menu.counterparties.name,
                              t.menu.counterparties.type,
                            ];
                            final rows =
                                partners.asMap().entries.map<List<String>>((
                                  entry,
                                ) {
                                  final index = entry.key + 1;
                                  final partner = entry.value;
                                  return [
                                    '$index',
                                    partner.name,
                                    getTypeName(partner.type ?? 0),
                                  ];
                                }).toList();

                            _localService.printReportAsPdf(
                              context: context,
                              title: t.menu.counterparties.title,
                              headers: headers,
                              rows: rows,
                            );
                          },
                          text: t.menu.counterparties.print,
                        ),
                        12.w,
                        OutlinedButtonWidget(
                          onPressed: () {
                            final headers = [
                              '№',
                              t.menu.counterparties.name,
                              t.menu.counterparties.type,
                            ];
                            final rows =
                                partners.asMap().entries.map<List<String>>((
                                  entry,
                                ) {
                                  final index = entry.key + 1;
                                  final partner = entry.value;
                                  return [
                                    '$index',
                                    partner.name,
                                    getTypeName(partner.type ?? 0),
                                  ];
                                }).toList();

                            _localService.exportToExcelGeneric(
                              fileName: t.menu.counterparties.title,
                              headers: headers,
                              rows: rows,
                              context: context,
                            );
                          },
                          text: t.menu.counterparties.export,
                        ),
                      ],
                    ),
                  20.h,
                ],
              ),
            ),
          ),
          12.h,

          if (partners.isNotEmpty)
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

                  double typeW = maxW * 0.33;
                  if (typeW < minTypeW) typeW = minTypeW;
                  if (typeW > maxTypeW) typeW = maxTypeW;

                  final nameW = maxW - menuW - typeW - margin * 2 - spacing * 2;

                  final isSmall = maxW < 360;
                  final headingH = isSmall ? 44.0 : 52.0;
                  final rowMinH = isSmall ? 44.0 : 52.0;

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
                        columns: [
                          DataColumn(
                            label: Text(
                              t.menu.counterparties.name,
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              t.menu.counterparties.type,
                              style: AppTextStyles.f16w500,
                            ),
                          ),
                          const DataColumn(label: Text('')),
                        ],
                        rows:
                            partners.map((p) {
                              final nameText = cut(p.name, 10);
                              final typeText = cut(
                                getTypeName(p.type ?? 0),
                                12,
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
                                              accountName: p.name,
                                              onConfirm: () {
                                                context
                                                    .read<MenuCubit>()
                                                    .deletePartner(p.id!);
                                                Navigator.pop(context);
                                              },
                                              title:
                                                  t
                                                      .menu
                                                      .counterparties
                                                      .deleteCounterparty,
                                            );
                                          },
                                          tapEdit: () async {
                                            final cubit =
                                                context.read<MenuCubit>();
                                            final navigator = Navigator.of(
                                              context,
                                            );

                                            final result = await navigator
                                                .pushNamed(
                                                  AppRoutes.editCounterparties,
                                                  arguments: p,
                                                );

                                            if (!mounted) return;
                                            if (result == true) {
                                              cubit.getPartnerData();
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
                  t.menu.counterparties.notFound,
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
