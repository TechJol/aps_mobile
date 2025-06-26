import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:decimal/decimal.dart';

class ForCounterpartiesPage extends StatefulWidget {
  const ForCounterpartiesPage({super.key});

  @override
  State<ForCounterpartiesPage> createState() => _ForCounterpartiesPageState();
}

class _ForCounterpartiesPageState extends State<ForCounterpartiesPage> {
  int currentPage = 1;
  final int rowsPerPage = 10;
  int? activeType;

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getPartnerData();
    context.read<MenuCubit>().getTransactionsWithAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: 'Категории контрагентов',
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          if (state is MenuPartnerDataSuccess) {
            final partners = state.partners ?? [];
            final partnerTypes = state.partnerTypes ?? [];

            if (partnerTypes.isEmpty) {
              return const Center(child: Text('Нет доступных категорий'));
            }

            if (activeType == null ||
                !partnerTypes.any((e) => e.id == activeType)) {
              activeType = partnerTypes.first.id!;
            }

            final filteredPartners =
                partners.where((e) => e.type == activeType).toList();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          partnerTypes.map((type) {
                            return categoryButton(
                              label: type.name,
                              isActive: activeType == type.id,
                              onTap: () {
                                setState(() {
                                  activeType = type.id!;
                                  currentPage = 1;
                                });
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  20.h,
                  filteredPartners.isEmpty
                      ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Text('Нет контрагентов в этой категории'),
                        ),
                      )
                      : _buildTableWithPagination(filteredPartners),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildTableWithPagination(List<PartnersModel> data) {
    final pageCount = (data.length / rowsPerPage).ceil();
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppColors.primaryColorLight,
            ),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            dataRowColor: WidgetStateProperty.all(Colors.white),
            columns: const [
              DataColumn(label: Text('№')),
              DataColumn(label: Text('Имя')),
              DataColumn(label: Text('Баланс')),
              DataColumn(label: Text('Контакты')),
            ],
            rows:
                paginatedData.asMap().entries.map((entry) {
                  final tx = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(tx.id.toString())),
                      DataCell(Text(tx.name)),
                      DataCell(
                        FutureBuilder<Map<int, Decimal>>(
                          future: _calculatePartnerBalance(tx.id!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('-');
                            }

                            if (snapshot.hasError) {
                              return Text('Ошибка');
                            }

                            final partnerBalance = snapshot.data?[tx.id];
                            return Text(
                              partnerBalance != null
                                  ? partnerBalance.toStringAsFixed(2)
                                  : '0',
                            );
                          },
                        ),
                      ),
                      DataCell(Text(tx.contactInfo ?? '')),
                    ],
                  );
                }).toList(),
          ),
          16.h,
          _buildPagination(pageCount),
        ],
      ),
    );
  }

  Future<Map<int, Decimal>> _calculatePartnerBalance(int partnerId) async {
    final cubit = context.read<MenuCubit>();
    final state = cubit.state;

    if (state is MenuTransactionsWithAccountsSuccess) {
      final transactions = state.transactions;

      Map<int, Decimal> partnerBalances = {};

      for (var transaction in transactions) {
        if (transaction.partners == partnerId) {
          final amount = Decimal.parse(transaction.amount ?? '0');
          if (partnerBalances.containsKey(partnerId)) {
            partnerBalances[partnerId] = partnerBalances[partnerId]! + amount;
          } else {
            partnerBalances[partnerId] = amount;
          }
        }
      }

      return partnerBalances;
    }

    return {};
  }

  Widget categoryButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? Colors.black : Colors.white,
          foregroundColor: isActive ? Colors.white : Colors.black,
          side: BorderSide(
            color: isActive ? Colors.black : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }

  Widget _buildPagination(int pageCount) {
    if (pageCount <= 1) {
      return const SizedBox.shrink();
    }

    int startPage = (currentPage - 5).clamp(1, pageCount);
    int endPage = (startPage + 9).clamp(startPage, pageCount);
    if (endPage - startPage < 9) {
      startPage = (endPage - 9).clamp(1, pageCount);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                currentPage > 1
                    ? () => goToPage(currentPage - 1, pageCount)
                    : null,
          ),
          for (int i = startPage; i <= endPage; i++) _pageButton(i, pageCount),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                currentPage < pageCount
                    ? () => goToPage(currentPage + 1, pageCount)
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _pageButton(int page, int pageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor:
              page == currentPage ? AppColors.primaryColorLight : null,
          foregroundColor: page == currentPage ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: () => goToPage(page, pageCount),
        child: Text('$page'),
      ),
    );
  }

  void goToPage(int page, int pageCount) {
    if (page >= 1 && page <= pageCount) {
      setState(() {
        currentPage = page;
      });
    }
  }
}
