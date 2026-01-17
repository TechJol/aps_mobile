// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterpartiesReportsPage extends StatefulWidget {
  const CounterpartiesReportsPage({super.key});

  @override
  _CounterpartiesReportsPageState createState() =>
      _CounterpartiesReportsPageState();
}

class _CounterpartiesReportsPageState extends State<CounterpartiesReportsPage> {
  final LocalService _localService = LocalService();
  final ScrollController _scrollController = ScrollController();

  int selectedYear = DateTime.now().year;
  late final TextEditingController _yearController;
  int? selectedTypeId;
  String? selectedTypeName;

  static const String _kgs = 'KGS';
  List<AllTransactionsModel> _transactions = [];
  List<PartnersModel> _partners = [];
  List<PartnerTypesModel> _types = [];
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: selectedYear.toString());
    final currentState = context.read<MenuCubit>().state;
    if (currentState is MenuTransactionsWithAccountsSuccess) {
      _transactions = currentState.transactions;
      _partners = currentState.partners;
      _types = currentState.partnerTypes ?? [];
      _hasData = true;
    } else if (currentState is MenuPartnerDataSuccess) {
      _partners = currentState.partners ?? _partners;
      _types = currentState.partnerTypes ?? _types;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuCubit = context.read<MenuCubit>();
      menuCubit.getTransactionsWithAccounts(force: true);
      menuCubit.getPartnerData(force: true);
    });
  }

  @override
  void dispose() {
    _yearController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.reportsByCounterpartiesPage.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        buildWhen: (previous, current) {
          return current is MenuTransactionsWithAccountsSuccess ||
              current is MenuPartnerDataSuccess;
        },
        builder: (context, state) {
          if (state is MenuTransactionsWithAccountsSuccess) {
            _transactions = state.transactions;
            _partners = state.partners;
            _types = state.partnerTypes ?? _types;
            _hasData = true;
          } else if (state is MenuPartnerDataSuccess) {
            _partners = state.partners ?? _partners;
            _types = state.partnerTypes ?? _types;
          }

          if (!_hasData) {
            return const SizedBox.shrink();
          }

          final typeLabel = t.menu.reportsByCounterpartiesPage.allTypes;
          final currentTypeName = selectedTypeName ?? typeLabel;

          final incomeRows = _buildPartnerRows(
            transactions: _transactions,
            partners: _partners,
            type: 'income',
            year: selectedYear,
            currency: _kgs,
            typeId: selectedTypeId,
          );

          final expenseRows = _buildPartnerRows(
            transactions: _transactions,
            partners: _partners,
            type: 'expense',
            year: selectedYear,
            currency: _kgs,
            typeId: selectedTypeId,
          );

          final headers = [
            t.menu.transactions.table.counterparty,
            ..._localizedMonthsShort(),
            t.menu.common.total,
          ];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              controller: _scrollController,
              children: [
                16.h,
                Row(
                  children: [
                    OutlinedButtonWidget(
                      text: t.menu.common.print,
                      onPressed: () {
                        final sections = _buildReportSections(
                          headers: headers,
                          incomeRows: incomeRows,
                          expenseRows: expenseRows,
                        );
                        _localService.printReportAsPdfSections(
                          context: context,
                          title:
                              '${t.menu.reportsByCounterpartiesPage.title} — $selectedYear',
                          sections: sections,
                        );
                      },
                    ),
                    12.w,
                    OutlinedButtonWidget(
                      text: t.menu.common.export,
                      onPressed: () {
                        final sections = _buildReportSections(
                          headers: headers,
                          incomeRows: incomeRows,
                          expenseRows: expenseRows,
                        );
                        _localService.exportToExcelSections(
                          fileName:
                              '${t.menu.reportsByCounterpartiesPage.filenamePrefix}$selectedYear',
                          sections: sections,
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
                20.h,
                Text(
                  '${t.menu.reportsByCounterpartiesPage.title} — $selectedYear',
                  style: AppTextStyles.f18w600,
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              t.menu.reportsByCounterpartiesPage.yearLabel,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    12.w,
                    Expanded(
                      flex: 3,
                      child: DropDownFormField(
                        label: t.menu.reportsByCounterpartiesPage.typeLabel,
                        items: [typeLabel, ..._types.map((e) => e.name)],
                        value: currentTypeName,
                        onChanged: (value) {
                          setState(() {
                            selectedTypeName = value;
                            if (value == typeLabel) {
                              selectedTypeId = null;
                            } else {
                              final selected = _types.firstWhere(
                                (e) => e.name == value,
                              );
                              selectedTypeId = selected.id;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                12.h,
                ElevatedButtonWidget(
                  text: t.operation.show,
                  onPressed: () {
                    final parsed = int.tryParse(_yearController.text);
                    if (parsed == null) return;
                    setState(() => selectedYear = parsed);
                  },
                ),
                24.h,
                ReportTableWidget(
                  title: t.menu.reportsByCounterpartiesPage.incomeTitle,
                  headers: headers,
                  rows: incomeRows,
                  columnWidths: _counterpartyTableWidths(),
                ),
                32.h,
                ReportTableWidget(
                  title: t.menu.reportsByCounterpartiesPage.expenseTitle,
                  headers: headers,
                  rows: expenseRows,
                  columnWidths: _counterpartyTableWidths(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PdfTableSection> _buildReportSections({
    required List<String> headers,
    required List<List<String>> incomeRows,
    required List<List<String>> expenseRows,
  }) {
    return [
      PdfTableSection(
        title: t.menu.reportsByCounterpartiesPage.incomeTitle,
        headers: headers,
        rows: incomeRows,
      ),
      PdfTableSection(
        title: t.menu.reportsByCounterpartiesPage.expenseTitle,
        headers: headers,
        rows: expenseRows,
      ),
    ];
  }

  List<List<String>> _buildPartnerRows({
    required List<AllTransactionsModel> transactions,
    required List<PartnersModel> partners,
    required String type,
    required int year,
    required String currency,
    int? typeId,
  }) {
    final Map<int, PartnersModel> partnerMap = {
      for (final partner in partners)
        if (partner.id != null) partner.id!: partner,
    };

    final Map<int, List<Decimal>> monthlyByPartner = {};

    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      DateTime parsedDate;
      try {
        parsedDate = DateTime.parse(tx.date!);
      } catch (_) {
        continue;
      }
      if (parsedDate.year != year) continue;
      if (tx.transactionType != type) continue;

      final isKgs =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      if (!isKgs) continue;

      final partnerId = tx.partners ?? tx.partner;
      if (partnerId == null) continue;

      final partner = partnerMap[partnerId];
      if (typeId != null && partner?.type != typeId) continue;

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final value = type == 'expense' ? amount.abs() : amount;
      final monthIndex = parsedDate.month - 1;

      monthlyByPartner.putIfAbsent(
        partnerId,
        () => List.filled(12, Decimal.zero),
      );
      final current = monthlyByPartner[partnerId];
      if (current != null) {
        current[monthIndex] = current[monthIndex] + value;
      }
    }

    final entries = monthlyByPartner.entries.toList()
      ..sort((a, b) {
        final nameA = partnerMap[a.key]?.name ?? '';
        final nameB = partnerMap[b.key]?.name ?? '';
        return nameA.compareTo(nameB);
      });

    return entries.map((entry) {
      final partner = partnerMap[entry.key];
      final name = partner?.name ?? t.menu.common.untitled;
      final values = entry.value;
      final total = values.fold(Decimal.zero, (acc, v) => acc + v);

      return [
        name,
        ...values.map((v) => v.toStringAsFixed(2)),
        total.toStringAsFixed(2),
      ];
    }).toList();
  }

  String? _txCurrency(AllTransactionsModel tx) {
    return tx.currency ?? 'KGS';
  }

  List<String> _localizedMonthsShort() => [
    t.menu.months.january,
    t.menu.months.february,
    t.menu.months.march,
    t.menu.months.april,
    t.menu.months.may,
    t.menu.months.june,
    t.menu.months.july,
    t.menu.months.august,
    t.menu.months.september,
    t.menu.months.october,
    t.menu.months.november,
    t.menu.months.december,
  ].map((m) => m.length <= 3 ? m : m.substring(0, 3)).toList();

  List<double> _counterpartyTableWidths() {
    return const [
      180, // counterparty
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      70,
      90, // total
    ];
  }
}
