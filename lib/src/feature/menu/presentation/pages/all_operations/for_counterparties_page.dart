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
    final s = context.read<MenuCubit>().state;
    if (s is! MenuTransactionsWithAccountsSuccess) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.forCounterparties.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }
          if (state is MenuTransactionsWithAccountsSuccess) {
            final partners = state.partners;
            final partnerTypes = state.partnerTypes ?? [];
            final balances = state.partnerBalances;

            if (partnerTypes.isEmpty) {
              return Center(child: Text(t.menu.forCounterparties.noTypes));
            }

            if (activeType == null ||
                !partnerTypes.any((e) => e.id == activeType)) {
              activeType = partnerTypes.first.id!;
            }

            final filteredPartners = partners
                .where((e) => e.type == activeType)
                .toList();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: partnerTypes
                          .map(
                            (type) => categoryButton(
                              label: type.name,
                              isActive: activeType == type.id,
                              onTap: () {
                                setState(() {
                                  activeType = type.id!;
                                  currentPage = 1;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  20.h,
                  filteredPartners.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              t.menu.forCounterparties.noPartnersInType,
                            ),
                          ),
                        )
                      : _buildTableWithPagination(
                          filteredPartners,
                          balances ?? {},
                        ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildTableWithPagination(
    List<PartnersModel> data,
    Map<int, Decimal> balances,
  ) {
    final pageCount = (data.length / rowsPerPage).ceil();
    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);

    // Настройки
    const borderColor = Color(0xFFE6E6E6);
    const colW = {
      0: FixedColumnWidth(50),
      1: FixedColumnWidth(200),
      2: FixedColumnWidth(120),
      3: FixedColumnWidth(200),
    };

    Widget cell(String text, {bool isHeader = false, Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          text,
          style: isHeader
              ? const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )
              : AppTextStyles.f14w500.copyWith(
                  color: color ?? AppColors.blackColor,
                ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Строки таблицы
    final tableRows = <TableRow>[];

    // Заголовок
    tableRows.add(
      TableRow(
        decoration: const BoxDecoration(color: AppColors.primaryColorLight),
        children: [
          cell(t.menu.common.numberSign, isHeader: true),
          cell(t.menu.forCounterparties.name, isHeader: true),
          cell(t.menu.forCounterparties.balance, isHeader: true),
          cell(t.menu.forCounterparties.contacts, isHeader: true),
        ],
      ),
    );

    // Данные
    for (final partner in paginatedData) {
      tableRows.add(
        TableRow(
          children: [
            cell('${data.indexOf(partner) + 1}'),
            cell(partner.name),
            // оставляю твою логику без изменений
            cell(balances[partner.id]?.toStringAsFixed(2) ?? '0.00'),
            cell(partner.contactInfo ?? ''),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: borderColor, width: 1),
              columnWidths: colW,
              children: tableRows,
            ),
          ),
          16.h,
          _buildPagination(pageCount),
        ],
      ),
    );
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
            onPressed: currentPage > 1
                ? () => goToPage(currentPage - 1, pageCount)
                : null,
          ),
          for (int i = startPage; i <= endPage; i++) _pageButton(i, pageCount),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < pageCount
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
          backgroundColor: page == currentPage
              ? AppColors.primaryColorLight
              : null,
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
