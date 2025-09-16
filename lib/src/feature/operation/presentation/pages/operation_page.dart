// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OperationPage extends StatefulWidget {
  const OperationPage({super.key});

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  String?
  _selectedPeriod; // хранит локализованный текст (week/oneMonth/threeMonth)

  @override
  void initState() {
    context.read<MenuCubit>().getTransactionsWithAccounts();
    context.read<CredentialCubit>().getUserById();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyFilter(String? period, DateTime? startDate, DateTime? endDate) {
    setState(() {
      _selectedPeriod = period; // локализованный текст периода или null
      _customStartDate = period == null ? startDate : null;
      _customEndDate = period == null ? endDate : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Лейбл фильтра: либо локализованный период, либо диапазон дат
    String filterLabel = '';
    if (_selectedPeriod != null) {
      filterLabel = _selectedPeriod!;
    } else if (_customStartDate != null && _customEndDate != null) {
      filterLabel =
          '${_customStartDate!.day.toString().padLeft(2, '0')}.${_customStartDate!.month.toString().padLeft(2, '0')}.${_customStartDate!.year}'
          ' - '
          '${_customEndDate!.day.toString().padLeft(2, '0')}.${_customEndDate!.month.toString().padLeft(2, '0')}.${_customEndDate!.year}';
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F7),
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/icons/logo_softkg.png'),
            ),
            Text(
              'SoftkgPro',
              style: AppTextStyles.f24w600.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.menu,
                  );
                  if (result == true) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Поле выбора периода
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextFormField(
                onTap: () {
                  _showPeriodPickerBottomSheet(context);
                },
                readOnly: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  labelStyle: AppTextStyles.f16w500,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                  fillColor: AppColors.backroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: AppColors.backroundColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      width: 1,
                      color: AppColors.backroundColor,
                    ),
                  ),
                  hintText:
                      filterLabel.isEmpty
                          ? t.operation.selectPeriod
                          : filterLabel,
                ),
              ),
            ),
          ),

          // Чип активного фильтра
          if (filterLabel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${t.operation.filter}: $filterLabel',
                    style: AppTextStyles.f14w500,
                  ),
                  TextButton(
                    onPressed: () {
                      _applyFilter(null, null, null);
                    },
                    child: Text(t.operation.resetFilter),
                  ),
                ],
              ),
            ),

          30.h,

          // Список операций
          BlocConsumer<MenuCubit, MenuState>(
            listener: (context, state) {
              if (state is MenuTransactionUpdatedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.operation.partnerSuccessUpdate)),
                );
              }
              if (state is MenuError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${t.operation.error}: ${state.message}'),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MenuLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MenuTransactionsWithAccountsSuccess) {
                final filtered = _filterTransactions(state.transactions);

                if (filtered.isEmpty) {
                  return Center(child: Text(t.operation.notOperation));
                }

                final grouped = _groupTransactionsByDate(filtered);
                _controller.forward();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.operation.operation, style: AppTextStyles.f20w600),
                      12.h,
                      ...grouped.entries.expand((entry) {
                        final dailyTxs = entry.value;
                        return List.generate(dailyTxs.length, (index) {
                          return FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                index * 0.1,
                                1.0,
                                curve: Curves.easeOut,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                if (dailyTxs[index].partners == null) {
                                  final result = await showAddPartnerSheed(
                                    context,
                                    dailyTxs[index],
                                  );

                                  if (result == true) {
                                    context
                                        .read<MenuCubit>()
                                        .getTransactionsWithAccounts();
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(t.operation.hasPartner),
                                    ),
                                  );
                                }
                              },
                              child: _buildTransactionItem(
                                dailyTxs[index],
                                state.partners,
                              ),
                            ),
                          );
                        });
                      }),
                    ],
                  ),
                );
              }

              if (state is MenuError) {
                return Center(
                  child: Text('${t.operation.error}: ${state.message}'),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  // --- ЛОГИКА ФИЛЬТРА -------------------------------------------------------

  List<AllTransactionsModel> _filterTransactions(
    List<AllTransactionsModel> txs,
  ) {
    final now = DateTime.now();
    DateTime? start, end;

    // сравниваем с локализованными значениями
    if (_selectedPeriod != null) {
      if (_selectedPeriod == t.operation.week) {
        start = now.subtract(const Duration(days: 7));
        end = now;
      } else if (_selectedPeriod == t.operation.oneMonth) {
        start = DateTime(now.year, now.month - 1, now.day);
        end = now;
      } else if (_selectedPeriod == t.operation.threeMonth) {
        start = DateTime(now.year, now.month - 3, now.day);
        end = now;
      }
    }

    if (_customStartDate != null && _customEndDate != null) {
      start = _customStartDate;
      end = _customEndDate;
    }

    if (start == null || end == null) return txs;

    return txs.where((tx) {
      final date = DateTime.tryParse(tx.date ?? '');
      if (date == null) return false;
      return date.isAfter(start!.subtract(const Duration(days: 1))) &&
          date.isBefore(end!.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, List<AllTransactionsModel>> _groupTransactionsByDate(
    List<AllTransactionsModel> transactions,
  ) {
    transactions.sort((a, b) {
      final aDate = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final bDate = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return bDate.compareTo(aDate);
    });

    final Map<String, List<AllTransactionsModel>> grouped = {};

    for (var tx in transactions) {
      final date = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
      final label =
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

      grouped.putIfAbsent(label, () => []);
      grouped[label]!.add(tx);
    }

    return grouped;
  }

  // --- ЭЛЕМЕНТ СПИСКА -------------------------------------------------------

  Widget _buildTransactionItem(
    AllTransactionsModel tx,
    List<PartnersModel> partners,
  ) {
    final bool isIncome = tx.transactionType == 'income';
    final DateTime date = DateTime.tryParse(tx.date ?? '') ?? DateTime.now();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final String amount = tx.amount ?? '';
    final String amountText = '$amount с';

    final Color bgColor =
        isIncome ? const Color(0xFFDFF7E2) : const Color(0xFFF9DCDC);
    final Color arrowColor =
        isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445);
    final IconData arrowIcon =
        isIncome ? Icons.call_received : Icons.north_west;

    final partnerName =
        partners
            .firstWhere(
              (p) => p.id == tx.partners,
              orElse: () => PartnersModel(name: t.operation.plusPartner),
            )
            .name;

    final TextStyle partnerNameStyle =
        partnerName == t.operation.plusPartner
            ? AppTextStyles.f14w500.copyWith(color: AppColors.primaryColor)
            : AppTextStyles.f14w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(arrowIcon, color: arrowColor, size: 20),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(partnerName, style: partnerNameStyle),
                4.h,
                Text(
                  formattedDate,
                  style: AppTextStyles.f12w400.copyWith(
                    color: AppColors.smallTextGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '' : '-'}$amountText',
            style: AppTextStyles.f16w600.copyWith(
              color:
                  isIncome ? const Color(0xFF56BC60) : const Color(0xFFE85445),
            ),
          ),
        ],
      ),
    );
  }

  // --- БОТТОМШИТ ВЫБОРА ПЕРИОДА И ДОБАВЛЕНИЯ ПАРТНЕРА -----------------------

  Future<void> _showPeriodPickerBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime? startDate = _customStartDate;
        DateTime? endDate = _customEndDate;
        String? selectedPeriod =
            _selectedPeriod; // локализованный текст или null

        return StatefulBuilder(
          builder: (context, setStateModal) {
            final bool datesEnabled = selectedPeriod == null;
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _dateField(
                          label: t.operation.start,
                          date: datesEnabled ? (startDate ?? DateTime.now()) : null,
                          enabled: datesEnabled,
                          onTap: () async {
                            if (!datesEnabled) return;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: (startDate ?? DateTime.now()),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setStateModal(() => startDate = picked);
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        _dateField(
                          label: t.operation.end,
                          date: datesEnabled ? (endDate ?? DateTime.now()) : null,
                          enabled: datesEnabled,
                          onTap: () async {
                            if (!datesEnabled) return;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: (endDate ?? DateTime.now()),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setStateModal(() => endDate = picked);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _periodOption(
                      t.operation.week,
                      selectedPeriod,
                      (val) => setStateModal(() {
                        selectedPeriod = val;
                        if (val != null) {
                          // период выбран — сбрасываем даты и дизейблим поля
                          startDate = null;
                          endDate = null;
                        } else {
                          // период снят — включаем поля дат с дефолтным сегодня
                          startDate ??= DateTime.now();
                          endDate ??= DateTime.now();
                        }
                      }),
                    ),
                    _periodOption(
                      t.operation.oneMonth,
                      selectedPeriod,
                      (val) => setStateModal(() {
                        selectedPeriod = val;
                        if (val != null) {
                          startDate = null;
                          endDate = null;
                        } else {
                          startDate ??= DateTime.now();
                          endDate ??= DateTime.now();
                        }
                      }),
                    ),
                    _periodOption(
                      t.operation.threeMonth,
                      selectedPeriod,
                      (val) => setStateModal(() {
                        selectedPeriod = val;
                        if (val != null) {
                          startDate = null;
                          endDate = null;
                        } else {
                          startDate ??= DateTime.now();
                          endDate ??= DateTime.now();
                        }
                      }),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'period':
                              selectedPeriod, // локализованный текст или null
                          'start': selectedPeriod == null ? (startDate ?? DateTime.now()) : null,
                          'end': selectedPeriod == null ? (endDate ?? DateTime.now()) : null,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColorLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(t.operation.show),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedPeriod = result['period'] as String?;
        _customStartDate = result['start'] as DateTime?;
        _customEndDate = result['end'] as DateTime?;
      });
    }
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.backroundColor.withOpacity(enabled ? 1.0 : 0.6),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.f12w400),
                  2.h,
                  if (date != null)
                    Text(
                      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                      style: AppTextStyles.f14w500,
                    )
                  else
                    Text(
                      '—',
                      style: AppTextStyles.f14w500.copyWith(
                        color: AppColors.greyerColorLight,
                      ),
                    ),
                ],
              ),
              SvgPicture.asset('assets/icons/calendar.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _periodOption(
    String label,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    final bool isSelected = label == selected;

    return GestureDetector(
      onTap: () => onChanged(isSelected ? null : label),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.backroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.f16w500.copyWith(color: Colors.black),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.grey.shade400,
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    return isSelected ? AppColors.primaryColor : Colors.white;
                  }),
                  checkColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => onChanged(isSelected ? null : label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showAddPartnerSheed(
    BuildContext context,
    AllTransactionsModel transaction,
  ) async {
    final cubit = context.read<MenuCubit>();
    cubit.getPartnerData();

    String? selectedPartnerType;
    String? selectedPartnerName;

    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: true,
      enableDrag: true,
      builder: (dialogContext) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(dialogContext).pop(true);
            return false;
          },
          child: BlocBuilder<MenuCubit, MenuState>(
            builder: (context, state) {
              if (state is MenuLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MenuPartnerDataSuccess) {
                return AlertDialog(
                  backgroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(
                    t.operation.addPartner,
                    style: AppTextStyles.f22w500,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.operation.selectTypeAndPartner,
                        style: AppTextStyles.f16w500.copyWith(
                          color: AppColors.greyerColorLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropDownFormField(
                        label: t.operation.selectType,
                        items: state.partnerTypes!.map((t) => t.name).toList(),
                        value: selectedPartnerType ?? '',
                        onChanged: (selectedType) {
                          selectedPartnerType = selectedType;
                          final id =
                              state.partnerTypes!
                                  .firstWhere((t) => t.name == selectedType)
                                  .id;
                          cubit.filterPartnersByType(id!);
                        },
                      ),
                      const SizedBox(height: 8),
                      DropDownFormField(
                        label: t.operation.selectPartner,
                        items:
                            state.filteredPartners
                                ?.map((p) => p.name)
                                .toList() ??
                            [],
                        value: selectedPartnerName ?? '',
                        onChanged: (val) => selectedPartnerName = val,
                      ),
                    ],
                  ),
                  actionsPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  actions: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                () => Navigator.of(dialogContext).pop(true),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.backroundColor,
                              side: const BorderSide(
                                color: AppColors.backroundColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              t.operation.cancel,
                              style: AppTextStyles.f16w500.copyWith(
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedPartnerName == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(t.operation.selectPartner),
                                  ),
                                );
                                return;
                              }

                              final selectedPartnerId =
                                  state.filteredPartners
                                      ?.firstWhere(
                                        (p) => p.name == selectedPartnerName,
                                        orElse:
                                            () => PartnersModel(
                                              id: null,
                                              name: '',
                                            ),
                                      )
                                      .id;

                              if (selectedPartnerId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(t.operation.notFoundPartner),
                                  ),
                                );
                                return;
                              }

                              await cubit.updatePartnerInTransaction(
                                transaction,
                                selectedPartnerId,
                              );
                              await cubit.getTransactionsWithAccounts();
                              Navigator.of(dialogContext).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColorLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              t.operation.yes,
                              style: AppTextStyles.f16w500.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );

    return result;
  }
}
