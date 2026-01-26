// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final LocalService _localService = LocalService();

  final int rowsPerPage = 10;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Загружаем данные только если их ещё нет — без лишнего лоадера
    final state = context.read<MenuCubit>().state;
    if (state is! MenuTransactionsWithAccountsSuccess) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
    }
  }

  /// перейти на страницу [page]
  void goToPage(int page, int pageCount) {
    if (page >= 1 && page <= pageCount) {
      setState(() {
        currentPage = page;
      });
    }
  }

  String _transactionLabel(AllTransactionsModel tx) {
    final description = tx.description?.trim();
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final amount = tx.amount?.trim();
    if (amount != null && amount.isNotEmpty) {
      final currency = tx.currency?.toUpperCase() ?? '';
      return currency.isEmpty ? amount : '$amount $currency';
    }

    if (tx.id != null) {
      return '#${tx.id}';
    }

    return t.menu.common.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(
        title: t.menu.transactions.title,
        backgroundColor: AppColors.whiteColor,
      ),
      body: BlocConsumer<MenuCubit, MenuState>(
        listenWhen: (previous, current) =>
            current is MenuTransactionUpdatedSuccess ||
            current is MenuTransactionDeletedSuccess ||
            current is DeleteError,
        listener: (context, state) {
          if (state is MenuTransactionUpdatedSuccess) {
            final label = _transactionLabel(state.updatedTransaction);
            final statusText = t.menu.transactions.table.edited;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$statusText: $label')));
          } else if (state is MenuTransactionDeletedSuccess) {
            final label = state.transactionLabel ?? '#${state.transactionId}';
            final statusText = t.menu.transactions.table.deleted;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$statusText: $label')));
          } else if (state is DeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${t.menu.error}: ${state.error}')),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is! MenuTransactionUpdatedSuccess &&
            current is! MenuTransactionDeletedSuccess &&
            current is! DeleteError,
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }
          if (state is MenuTransactionsWithAccountsSuccess) {
            final transactions = state.transactions;
            final accounts = state.accounts;
            final reasons = state.reasons;

            if (transactions.isEmpty) {
              return Center(child: Text(t.menu.transactions.notFound));
            }
            return _buildTableWithPagination(
              transactions,
              accounts,
              reasons,
              state.partners,
            );
          }

          // MenuInitial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _showEditTransactionSheet({
    required AllTransactionsModel transaction,
    required List<AccountModel> accounts,
    required List<IncomeExpenseReasons> reasons,
    required List<PartnersModel> partners,
  }) async {
    if (transaction.id == null) return;

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: _EditTransactionSheet(
            transaction: transaction,
            accounts: accounts,
            reasons: reasons,
            partners: partners,
          ),
        );
      },
    );
  }

  Widget _buildTableWithPagination(
    List<AllTransactionsModel> data,
    List<AccountModel> accounts,
    List<IncomeExpenseReasons> reasons,
    List<PartnersModel> partners,
  ) {
    String getAccountName(int id) {
      return accounts
          .firstWhere(
            (acc) => acc.id == id,
            orElse: () => AccountModel(
              name: t.menu.common.unknown,
              accountType: '',
              company: 0,
            ),
          )
          .name;
    }

    String getReasonName(int id) {
      return reasons
          .firstWhere(
            (reason) => reason.id == id,
            orElse: () => IncomeExpenseReasons(
              name: t.menu.common.unknown,
              type: '',
              company: 0,
            ),
          )
          .name;
    }

    String getPartnerName(int id) {
      return partners
          .firstWhere(
            (p) => p.id == id,
            orElse: () =>
                PartnersModel(name: t.menu.common.unknown, company: 0),
          )
          .name;
    }

    final start = (currentPage - 1) * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(start, end);
    final pageCount = (data.length / rowsPerPage).ceil();

    // ===== Настройки таблицы =====
    const borderColor = Color(0xFFE6E6E6);
    const colW = {
      0: FixedColumnWidth(50), // №
      1: FixedColumnWidth(100), // Сумма
      2: FixedColumnWidth(50), // Валюта (кратко)
      3: FixedColumnWidth(90), // Дата
      4: FixedColumnWidth(70), // Тип
      5: FixedColumnWidth(120), // Счет
      6: FixedColumnWidth(150), // Статья
      7: FixedColumnWidth(150), // Контрагент
      8: FixedColumnWidth(200), // Комментарий
      9: FixedColumnWidth(48), // Действия
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

    // ===== Формируем строки таблицы =====
    final tableRows = <TableRow>[];
    // Шапка
    tableRows.add(
      TableRow(
        decoration: const BoxDecoration(color: AppColors.primaryColorLight),
        children: [
          cell(t.menu.common.numberSign, isHeader: true),
          cell(t.menu.transactions.table.amount, isHeader: true),
          cell(t.menu.transactions.table.currencyShort, isHeader: true),
          cell(t.menu.transactions.table.date, isHeader: true),
          cell(t.menu.transactions.table.type, isHeader: true),
          cell(t.menu.transactions.table.account, isHeader: true),
          cell(t.menu.transactions.table.article, isHeader: true),
          cell(t.menu.transactions.table.counterparty, isHeader: true),
          cell(t.menu.transactions.table.comment, isHeader: true),
          cell('', isHeader: true),
        ],
      ),
    );

    // Данные
    for (final tx in paginatedData) {
      final label = _transactionLabel(tx);
      tableRows.add(
        TableRow(
          children: [
            cell('${data.indexOf(tx) + 1}'),
            cell(tx.amount?.toString() ?? ''),
            cell(tx.currency ?? ''),
            cell(
              tx.date != null
                  ? DateFormat('dd.MM.yyyy').format(DateTime.parse(tx.date!))
                  : '',
            ),
            cell(
              tx.transactionType == 'income'
                  ? t.menu.articles.income
                  : t.menu.articles.expense,
            ),
            cell(getAccountName(tx.account ?? 0)),
            cell(getReasonName(tx.incomeExpenseReason ?? 0)),
            cell(getPartnerName(tx.partners ?? 0)),
            cell(tx.description ?? ''),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Align(
                alignment: Alignment.center,
                child: PopupMenuWid(
                  context: context,
                  tapDelete: tx.id == null
                      ? null
                      : () {
                          ShowSheet().showDeleteDialog(
                            context,
                            accountName: label,
                            title: t.menu.delete,
                            message: '${t.menu.delete} "$label"?',
                            onConfirm: () {
                              context.read<MenuCubit>().deleteTransaction(
                                tx.id!,
                                label: label,
                              );
                            },
                          );
                        },
                  tapEdit: tx.id == null
                      ? null
                      : () => _showEditTransactionSheet(
                          transaction: tx,
                          accounts: accounts,
                          reasons: reasons,
                          partners: partners,
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // ===== Кнопки =====
          Row(
            children: [
              OutlinedButtonWidget(
                text: t.menu.common.print,
                onPressed: () {
                  final headers = [
                    t.menu.common.numberSign,
                    t.menu.transactions.table.amount,
                    t.menu.transactions.table.currency,
                    t.menu.transactions.table.date,
                    t.menu.transactions.table.type,
                    t.menu.transactions.table.account,
                    t.menu.transactions.table.article,
                    t.menu.transactions.table.counterparty,
                    t.menu.transactions.table.comment,
                  ];

                  final rows = data.asMap().entries.map<List<String>>((entry) {
                    final tx = entry.value;
                    final index = entry.key + 1;
                    return [
                      '$index',
                      tx.amount?.toString() ?? '',
                      tx.currency ?? '',
                      tx.date != null
                          ? DateFormat(
                              'dd.MM.yyyy',
                            ).format(DateTime.parse(tx.date!))
                          : '',
                      tx.transactionType == 'income'
                          ? t.menu.articles.income
                          : t.menu.articles.expense,
                      getAccountName(tx.account ?? 0),
                      getReasonName(tx.incomeExpenseReason ?? 0),
                      getPartnerName(tx.partners ?? 0),
                      tx.description ?? '',
                    ];
                  }).toList();

                  _localService.printReportAsPdf(
                    context: context,
                    title: t.menu.transactions.printTitle,
                    headers: headers,
                    rows: rows,
                  );
                },
              ),
              12.w,
              OutlinedButtonWidget(
                text: t.menu.common.export,
                onPressed: () {
                  final headers = [
                    t.menu.common.numberSign,
                    t.menu.transactions.table.amount,
                    t.menu.transactions.table.currency,
                    t.menu.transactions.table.date,
                    t.menu.transactions.table.type,
                    t.menu.transactions.table.account,
                    t.menu.transactions.table.article,
                    t.menu.transactions.table.counterparty,
                    t.menu.transactions.table.comment,
                  ];

                  final rows = data.asMap().entries.map<List<String>>((entry) {
                    final tx = entry.value;
                    final index = entry.key + 1;
                    return [
                      '$index',
                      tx.amount?.toString() ?? '',
                      tx.currency ?? '',
                      tx.date != null
                          ? DateFormat(
                              'dd.MM.yyyy',
                            ).format(DateTime.parse(tx.date!))
                          : '',
                      tx.transactionType == 'income'
                          ? t.menu.articles.income
                          : t.menu.articles.expense,
                      getAccountName(tx.account ?? 0),
                      getReasonName(tx.incomeExpenseReason ?? 0),
                      getPartnerName(tx.partners ?? 0),
                      tx.description ?? '',
                    ];
                  }).toList();

                  _localService.exportToExcelGeneric(
                    fileName: t.menu.transactions.fileName,
                    headers: headers,
                    rows: rows,
                    context: context,
                  );
                },
              ),
            ],
          ),
          20.h,

          // ===== Таблица =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: borderColor, width: 1),
              columnWidths: colW,
              children: tableRows,
            ),
          ),
          20.h,

          // ===== Пагинация =====
          _buildPagination(pageCount),
        ],
      ),
    );
  }

  Widget _buildPagination(int pageCount) {
    if (pageCount <= 1) {
      return const SizedBox.shrink(); // не показываем пагинацию если одна страница
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
}

class _EditTransactionSheet extends StatefulWidget {
  const _EditTransactionSheet({
    required this.transaction,
    required this.accounts,
    required this.reasons,
    required this.partners,
  });

  final AllTransactionsModel transaction;
  final List<AccountModel> accounts;
  final List<IncomeExpenseReasons> reasons;
  final List<PartnersModel> partners;

  @override
  State<_EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<_EditTransactionSheet> {
  static const List<Map<String, String>> _currencyOptions = [
    {'code': 'kgs', 'label': 'KGS'},
    {'code': 'usd', 'label': 'USD'},
    {'code': 'eur', 'label': 'EUR'},
    {'code': 'rub', 'label': 'RUB'},
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateController;
  late DateTime _selectedDate;
  late String _selectedCurrency;
  late String _selectedType;
  int? _selectedAccountId;
  int? _selectedReasonId;
  int? _selectedPartnerId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;

    _amountController = TextEditingController(text: tx.amount ?? '');
    _descriptionController = TextEditingController(text: tx.description ?? '');

    _selectedDate = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
    _dateController = TextEditingController(text: _formatDate(_selectedDate));

    _selectedCurrency = (tx.currency ?? 'kgs').toLowerCase();
    if (!_currencyOptions.any((opt) => opt['code'] == _selectedCurrency)) {
      _selectedCurrency = 'kgs';
    }

    _selectedType = tx.transactionType ?? 'income';
    if (_selectedType != 'income' && _selectedType != 'expense') {
      _selectedType = 'income';
    }

    _selectedAccountId = tx.account;
    _selectedReasonId = tx.incomeExpenseReason;
    _selectedPartnerId = tx.partners;

    if (!widget.accounts.any((account) => account.id == _selectedAccountId)) {
      _selectedAccountId = null;
    }
    if (!widget.reasons.any((reason) => reason.id == _selectedReasonId)) {
      _selectedReasonId = null;
    }
    if (!widget.partners.any((partner) => partner.id == _selectedPartnerId)) {
      _selectedPartnerId = null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionTypes = <String, String>{
      'income': t.menu.articles.income,
      'expense': t.menu.articles.expense,
    };

    return BlocListener<MenuCubit, MenuState>(
      listenWhen: (previous, current) {
        if (!_isSubmitting) return false;
        return current is MenuTransactionsWithAccountsSuccess ||
            current is MenuError;
      },
      listener: (context, state) {
        if (state is MenuError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${t.menu.error}: ${state.message}')),
          );
          setState(() => _isSubmitting = false);
        } else if (state is MenuTransactionsWithAccountsSuccess) {
          Navigator.of(context).pop(true);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.greyerColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Text(t.menu.edit, style: AppTextStyles.f20w600),
              16.h,
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: _inputDecoration(t.menu.transactions.table.amount),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.menu.transactions.table.amount;
                  }
                  return null;
                },
              ),
              12.h,
              DropdownButtonFormField<String>(
                initialValue: _selectedCurrency,
                decoration: _inputDecoration(
                  t.menu.transactions.table.currency,
                ),
                items: _currencyOptions
                    .map(
                      (opt) => DropdownMenuItem<String>(
                        value: opt['code'],
                        child: Text(opt['label'] ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedCurrency = value);
                },
              ),
              12.h,
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: _inputDecoration(t.menu.transactions.table.date)
                    .copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                onTap: _pickDateTime,
              ),
              12.h,
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: _inputDecoration(t.menu.transactions.table.type),
                items: transactionTypes.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedType = value);
                },
              ),
              12.h,
              DropdownButtonFormField<int>(
                initialValue: _selectedAccountId,
                decoration: _inputDecoration(t.menu.transactions.table.account),
                items: widget.accounts
                    .where((account) => account.id != null)
                    .map(
                      (account) => DropdownMenuItem<int>(
                        value: account.id!,
                        child: Text(account.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedAccountId = value),
                validator: (value) {
                  if (value == null) {
                    return t.menu.transactions.table.account;
                  }
                  return null;
                },
              ),
              12.h,
              DropdownButtonFormField<int>(
                initialValue: _selectedReasonId,
                decoration: _inputDecoration(t.menu.transactions.table.article),
                items: widget.reasons
                    .where((reason) => reason.id != null)
                    .map(
                      (reason) => DropdownMenuItem<int>(
                        value: reason.id!,
                        child: Text(reason.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedReasonId = value),
                validator: (value) {
                  if (value == null) {
                    return t.menu.transactions.table.article;
                  }
                  return null;
                },
              ),
              12.h,
              DropdownButtonFormField<int?>(
                initialValue: _selectedPartnerId,
                decoration: _inputDecoration(
                  t.menu.transactions.table.counterparty,
                ),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(t.menu.common.unknown),
                  ),
                  ...widget.partners
                      .where((partner) => partner.id != null)
                      .map(
                        (partner) => DropdownMenuItem<int?>(
                          value: partner.id,
                          child: Text(partner.name),
                        ),
                      ),
                ],
                onChanged: (value) =>
                    setState(() => _selectedPartnerId = value),
              ),
              12.h,
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _inputDecoration(t.menu.transactions.table.comment),
              ),
              20.h,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColorLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(t.menu.save),
                ),
              ),
              MediaQuery.paddingOf(context).bottom > 0 ? 0.h : 12.h,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      _dateController.text = _formatDate(_selectedDate);
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    if (widget.transaction.id == null) return;

    setState(() => _isSubmitting = true);
    FocusScope.of(context).unfocus();

    final updated = widget.transaction.copyWith(
      amount: _amountController.text.trim(),
      currency: _selectedCurrency,
      date: _selectedDate.toIso8601String(),
      transactionType: _selectedType,
      account: _selectedAccountId,
      incomeExpenseReason: _selectedReasonId,
      partners: _selectedPartnerId,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    context.read<MenuCubit>().updateTransaction(
      updated,
      widget.transaction.id!,
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy – HH:mm').format(date);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.f16w500,
      filled: true,
      fillColor: AppColors.backroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.backroundColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryColorLight),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
