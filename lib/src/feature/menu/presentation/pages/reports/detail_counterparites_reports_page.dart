// ignore_for_file: library_private_types_in_public_api

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailCounterparitesReportsPage extends StatefulWidget {
  const DetailCounterparitesReportsPage({super.key});

  @override
  _DetailCounterparitesReportsPageState createState() =>
      _DetailCounterparitesReportsPageState();
}

class _DetailCounterparitesReportsPageState
    extends State<DetailCounterparitesReportsPage> {
  final LocalService _localService = LocalService();

  int? _selectedYear;
  int? _selectedTypeId;
  int? _selectedPartnerId;
  String? _selectedTypeName;
  String? _selectedPartnerName;

  static const String _kgs = 'KGS';
  List<AllTransactionsModel> _transactions = [];
  List<PartnersModel> _partners = [];
  List<PartnerTypesModel> _types = [];
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: t.menu.reportsByCounterpartyDetail.title,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          final partners = _partners;
          final types = _types;
          final years = _availableYears(_transactions);

          final selectedYear =
              _selectedYear ?? (years.isNotEmpty ? years.first : null);
          if (_selectedYear == null && selectedYear != null) {
            _selectedYear = selectedYear;
          }

          final typeLabel = t.menu.reportsByCounterpartiesPage.allTypes;
          final partnerLabel = t.menu.reportsByCounterpartyDetail.selectPartner;

          final filteredPartners = _selectedTypeId == null
              ? partners
              : partners.where((p) => p.type == _selectedTypeId).toList();

          final partnerMap = {
            for (final partner in partners)
              if (partner.id != null) partner.id!: partner,
          };

          final partnerId = _selectedPartnerId;
          final reportData = (selectedYear == null || partnerId == null)
              ? _PartnerReport.empty()
              : _buildPartnerReport(
                  transactions: _transactions,
                  partnerId: partnerId,
                  year: selectedYear,
                  currency: _kgs,
                );

          final totalsLabel =
              _selectedPartnerName ??
              (partnerId != null ? partnerMap[partnerId]?.name : null);

          final tableHeaders = [
            t.menu.common.month,
            t.menu.incomeExpenseSummary.income,
            t.menu.incomeExpenseSummary.expense,
          ];

          final tableRows = _buildMonthlyRows(reportData);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                16.h,
                Row(
                  children: [
                    OutlinedButtonWidget(
                      text: t.menu.common.print,
                      onPressed: () {
                        if (selectedYear == null || partnerId == null) return;
                        final sections = _buildPrintSections(
                          tableHeaders: tableHeaders,
                          tableRows: tableRows,
                          report: reportData,
                          partnerName: totalsLabel ?? '',
                        );
                        _localService.printReportAsPdfSections(
                          context: context,
                          title:
                              '${t.menu.reportsByCounterpartyDetail.title} — $selectedYear',
                          sections: sections,
                        );
                      },
                    ),
                    12.w,
                    OutlinedButtonWidget(
                      text: t.menu.common.export,
                      onPressed: () {
                        if (selectedYear == null || partnerId == null) return;
                        final sections = _buildPrintSections(
                          tableHeaders: tableHeaders,
                          tableRows: tableRows,
                          report: reportData,
                          partnerName: totalsLabel ?? '',
                        );
                        _localService.exportToExcelSections(
                          fileName:
                              '${t.menu.reportsByCounterpartiesPage.filenamePrefix}$selectedYear ',
                          sections: sections,
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
                20.h,
                Text(
                  t.menu.reportsByCounterpartyDetail.title,
                  style: AppTextStyles.f18w600,
                ),
                16.h,
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropDownFormField(
                        label: t.menu.reportsByCounterpartyDetail.selectYear,
                        items: years.map((y) => y.toString()).toList(),
                        value: selectedYear?.toString(),
                        isSettingDropdown: false,
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = int.tryParse(value ?? '');
                          });
                        },
                      ),
                    ),
                    12.w,
                    Expanded(
                      flex: 2,
                      child: DropDownFormField(
                        label: t.menu.reportsByCounterpartyDetail.selectType,
                        items: [typeLabel, ...types.map((e) => e.name)],
                        value: _selectedTypeName ?? typeLabel,
                        isSettingDropdown: false,
                        onChanged: (value) {
                          setState(() {
                            _selectedTypeName = value;
                            if (value == typeLabel) {
                              _selectedTypeId = null;
                            } else {
                              final selected = types.firstWhere(
                                (e) => e.name == value,
                              );
                              _selectedTypeId = selected.id;
                            }
                            _selectedPartnerId = null;
                            _selectedPartnerName = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                12.h,
                DropDownFormField(
                  label: t.menu.reportsByCounterpartyDetail.selectPartner,
                  items: [partnerLabel, ...filteredPartners.map((e) => e.name)],
                  value: _selectedPartnerName ?? partnerLabel,
                  isSettingDropdown: false,
                  onChanged: (value) {
                    setState(() {
                      _selectedPartnerName = value;
                      if (value == partnerLabel) {
                        _selectedPartnerId = null;
                      } else {
                        final selected = filteredPartners.firstWhere(
                          (e) => e.name == value,
                        );
                        _selectedPartnerId = selected.id;
                      }
                    });
                  },
                ),
                12.h,
                ElevatedButtonWidget(
                  text: t.operation.show,
                  onPressed: () => setState(() {}),
                ),
                16.h,
                if (partnerId != null) ...[
                  Text(
                    '${t.menu.transactions.table.counterparty}: ${totalsLabel ?? ''}',
                    style: AppTextStyles.f16w500,
                  ),
                  12.h,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.greyColorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.menu.reportsByCounterpartyDetail.totalIncome}: ${reportData.incomeTotal} KGS',
                          style: AppTextStyles.f14w500.copyWith(
                            color: AppColors.greenColor,
                          ),
                        ),
                        6.h,
                        Text(
                          '${t.menu.reportsByCounterpartyDetail.totalExpense}: ${reportData.expenseTotal} KGS',
                          style: AppTextStyles.f14w500.copyWith(
                            color: AppColors.redColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.h,
                  ReportTableWidget(
                    headers: tableHeaders,
                    rows: tableRows,
                    columnWidths: const [100, 160, 160],
                    headerColor: const Color(0xFFD7EEE2),
                    headerTextColor: AppColors.blackColor,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<int> _availableYears(List<AllTransactionsModel> transactions) {
    final years = <int>{};
    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      final parsed = DateTime.tryParse(tx.date!);
      if (parsed == null) continue;
      years.add(parsed.year);
    }
    final list = years.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  _PartnerReport _buildPartnerReport({
    required List<AllTransactionsModel> transactions,
    required int partnerId,
    required int year,
    required String currency,
  }) {
    final income = List<Decimal>.filled(12, Decimal.zero);
    final expense = List<Decimal>.filled(12, Decimal.zero);

    for (final tx in transactions) {
      if (tx.date == null || tx.date!.isEmpty) continue;
      final parsed = DateTime.tryParse(tx.date!);
      if (parsed == null || parsed.year != year) continue;

      final isKgs =
          (_txCurrency(tx)?.toUpperCase() ?? '') == currency.toUpperCase();
      if (!isKgs) continue;

      final txPartnerId = tx.partners ?? tx.partner;
      if (txPartnerId != partnerId) continue;

      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
      final monthIndex = parsed.month - 1;

      if (tx.transactionType == 'income') {
        income[monthIndex] += amount;
      } else if (tx.transactionType == 'expense') {
        expense[monthIndex] += amount.abs();
      }
    }

    final totalIncome = income.fold(Decimal.zero, (acc, v) => acc + v);
    final totalExpense = expense.fold(Decimal.zero, (acc, v) => acc + v);
    return _PartnerReport(
      income: income,
      expense: expense,
      incomeTotal: totalIncome.toStringAsFixed(2),
      expenseTotal: totalExpense.toStringAsFixed(2),
    );
  }

  List<List<String>> _buildMonthlyRows(_PartnerReport report) {
    final months = _localizedMonthsShort();
    return List.generate(12, (i) {
      return [
        months[i],
        report.income[i].toStringAsFixed(2),
        report.expense[i].toStringAsFixed(2),
      ];
    });
  }

  List<PdfTableSection> _buildPrintSections({
    required List<String> tableHeaders,
    required List<List<String>> tableRows,
    required _PartnerReport report,
    required String partnerName,
  }) {
    return [
      PdfTableSection(
        title: partnerName.isEmpty
            ? t.menu.reportsByCounterpartyDetail.totalsTitle
            : '${t.menu.reportsByCounterpartyDetail.totalsTitle}: $partnerName',
        headers: [t.menu.common.title, t.menu.common.amountKgs],
        rows: [
          [t.menu.reportsByCounterpartyDetail.totalIncome, report.incomeTotal],
          [
            t.menu.reportsByCounterpartyDetail.totalExpense,
            report.expenseTotal,
          ],
        ],
      ),
      PdfTableSection(
        title: t.menu.reportsByCounterpartyDetail.monthlyTitle,
        headers: tableHeaders,
        rows: tableRows,
      ),
    ];
  }

  String? _txCurrency(AllTransactionsModel tx) => tx.currency ?? 'KGS';

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
}

class _PartnerReport {
  const _PartnerReport({
    required this.income,
    required this.expense,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  final List<Decimal> income;
  final List<Decimal> expense;
  final String incomeTotal;
  final String expenseTotal;

  static _PartnerReport empty() {
    return _PartnerReport(
      income: List<Decimal>.filled(12, Decimal.zero),
      expense: List<Decimal>.filled(12, Decimal.zero),
      incomeTotal: '0.00',
      expenseTotal: '0.00',
    );
  }
}
