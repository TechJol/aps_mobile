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
    context.read<MenuCubit>().getPartnerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Контрагенты',
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
            final error = state.error;
            String message =
                error is DioException
                    ? 'Ошибка удаления [${error.response?.statusCode}]: ${error.response?.data ?? error.message}'
                    : 'Ошибка при удалении: $error';
            return Center(child: Text(message));
          }

          if (state is MenuPartnerDataSuccess) {
            return _buildTableSection(
              context,
              state.partners!,
              state.partnerTypes!,
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
            orElse: () => PartnerTypesModel(id: typeId, name: 'Неизвестно'),
          )
          .name;
    }

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
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addCounterparties,
                          );
                        },
                        label: const Text(
                          'Добавить контрагента',
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
                if (partners.isNotEmpty)
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {
                          final headers = ['№', 'Название', 'Тип'];
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
                            fileName: 'Контрагенты',
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
        if (partners.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
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
                      label: Text('Тип', style: AppTextStyles.f16w500),
                    ),
                    DataColumn(label: Text('')),
                  ],
                  rows:
                      partners.map((partner) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(partner.name, style: AppTextStyles.f16w500),
                            ),
                            DataCell(
                              Text(
                                getTypeName(partner.type ?? 0),
                                style: AppTextStyles.f16w500,
                              ),
                            ),
                            DataCell(
                              PopupMenuWid(
                                context: context,
                                tapDelete: () {
                                  ShowSheet().showDeleteDialog(
                                    context,
                                    accountName: partner.name,
                                    onConfirm: () {
                                      context.read<MenuCubit>().deletePartner(
                                        partner.id!,
                                      );
                                      Navigator.pop(context);
                                    },
                                    title: 'Удалить контрагента',
                                  );
                                },
                                tapEdit: () async {
                                  final result = await Navigator.pushNamed(
                                    context,
                                    AppRoutes.editCounterparties,
                                    arguments: partner,
                                  );
                                  if (result == true) {
                                    context.read<MenuCubit>().getPartnerData();
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
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
