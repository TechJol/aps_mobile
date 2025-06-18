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
  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getPartners();
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

          if (state is MenuPartnerSuccess) {
            final partners = state.partners;
            return _buildTableSection(context, partners);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTableSection(
    BuildContext context,
    List<PartnersModel> partners,
  ) {
    final hasPartners = partners.isNotEmpty;

    return Column(
      children: [
        // Заголовок и кнопка "Добавить"
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
                if (hasPartners)
                  Row(
                    children: [
                      OutlinedButtonWidget(
                        onPressed: () {},
                        text: 'Распечатать',
                      ),
                      12.w,
                      OutlinedButtonWidget(
                        onPressed: () {},
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

        if (hasPartners)
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
                                '${partner.type}',
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
                                tapEdit: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.editCounterparties,
                                    arguments: partner,
                                  );
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
