import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class IncomePage {
  Future<bool?> showIncomeBottomSheet({
    required BuildContext context,
    required String title,
    required String transactionType,
  }) async {
    final selectedDateNotifier = ValueNotifier<DateTime>(DateTime.now());
    final TextEditingController dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy – HH:mm').format(selectedDateNotifier.value),
    );
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final List<_CurrencyOption> currencyOptions = const [
      _CurrencyOption(label: 'KGS', code: 'kgs'),
      _CurrencyOption(label: 'USD', code: 'usd'),
      _CurrencyOption(label: 'EUR', code: 'eur'),
      _CurrencyOption(label: 'RUB', code: 'rub'),
    ];
    final ValueNotifier<_CurrencyOption> selectedCurrency =
        ValueNotifier<_CurrencyOption>(currencyOptions.first);
    final currencyButtonKey = GlobalKey();

    String? selectedAccountName;
    int? selectedAccountId;
    String? selectedReasonName;
    int? selectedReasonId;

    context.read<IncomeCubit>().getAccount();
    context.read<IncomeCubit>().getIncomeExpenseReasons();

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => BlocListener<IncomeCubit, IncomeState>(
        listenWhen: (previous, current) {
          // реагируем только на сохранение/ошибку
          return current.incomeSaved || current.error != null;
        },
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.incomeSaved) {
            Navigator.pop(context, true);
            context.read<IncomeCubit>().resetState();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.65,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 100,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          Center(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Дата/время
                      TextFormField(
                        readOnly: true,
                        controller: dateController,
                        decoration: InputDecoration(
                          filled: true,
                          labelStyle: AppTextStyles.f16w500,
                          fillColor: AppColors.backroundColor,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _showCustomDateTimePicker(
                                context,
                                selectedDateNotifier.value,
                                (picked) {
                                  selectedDateNotifier.value = picked;
                                  dateController.text = DateFormat(
                                    'dd.MM.yyyy – HH:mm',
                                  ).format(picked);
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: SizedBox(
                                height: 24,
                                child: SvgPicture.asset(
                                  'assets/icons/calendar.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
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
                              color: AppColors.backroundColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Dropdown: Account
                      BlocBuilder<IncomeCubit, IncomeState>(
                        builder: (context, state) {
                          if (state.isLoading && state.accounts.isEmpty) {
                            return const CircularProgressIndicator();
                          }

                          if (state.accounts.isEmpty) {
                            return DropDownFormField(
                              items: const [],
                              label: t.income.account, // "Счет" / "Account"
                              value: t
                                  .income
                                  .notAccount, // "Нет счетов.." / "No accounts.."
                              onChanged: (_) {},
                            );
                          }

                          return DropDownFormField(
                            items: state.accounts.map((e) => e.name).toList(),
                            label: t.income.account,
                            value: selectedAccountName,
                            onChanged: (val) {
                              selectedAccountName = val;
                              selectedAccountId = state.accounts
                                  .firstWhere((e) => e.name == val)
                                  .id;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Сумма
                      ValueListenableBuilder<_CurrencyOption>(
                        valueListenable: selectedCurrency,
                        builder: (context, currency, _) => TextFieldWid(
                          label: t.income.sum, // "Сумма" / "Sum"
                          controller: amountController,
                          suffixIcon: GestureDetector(
                            key: currencyButtonKey,
                            onTap: () => _showCurrencyMenu(
                              context,
                              currencyButtonKey,
                              selectedCurrency,
                              currencyOptions,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: Image.asset(
                                      'assets/icons/currencies.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    currency.label,
                                    style: AppTextStyles.f14w500.copyWith(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.expand_more,
                                    size: 18,
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Dropdown: Reason
                      BlocBuilder<IncomeCubit, IncomeState>(
                        builder: (context, state) {
                          if (state.isLoading && state.reasons.isEmpty) {
                            return const CircularProgressIndicator();
                          }

                          if (state.reasons.isEmpty) {
                            return DropDownFormField(
                              items: const [],
                              label: t.income.article, // "Статья" / "Article"
                              value: t
                                  .income
                                  .notArticle, // "Нет статей.." / "No articles.."
                              onChanged: (_) {},
                            );
                          }

                          final filteredReasons = state.reasons
                              .where((e) => e.type == transactionType)
                              .toList();

                          return DropDownFormField(
                            items: filteredReasons.map((e) => e.name).toList(),
                            label: t.income.article,
                            value: selectedReasonName,
                            onChanged: (val) {
                              selectedReasonName = val;
                              selectedReasonId = state.reasons
                                  .firstWhere((e) => e.name == val)
                                  .id;
                            },
                            // bottomGap:
                            //     (filteredReasons.length < 2) ? 200 : 20,
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Описание
                      TextFormField(
                        maxLength: 160,
                        maxLines: 3,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          filled: true,
                          labelStyle: AppTextStyles.f16w500,
                          fillColor: AppColors.backroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: t
                              .income
                              .description, // "Описание" / "Description"
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Save button
                      BlocBuilder<IncomeCubit, IncomeState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const CircularProgressIndicator();
                          }

                          return ElevatedButton(
                            onPressed: () {
                              if (selectedAccountId == null ||
                                  selectedReasonId == null ||
                                  amountController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      t.income.pleaseFillInAllFields,
                                    ),
                                  ), // "Пожалуйста, заполните все поля."
                                );
                                return;
                              }

                              final currency = selectedCurrency.value;
                              final income = IncomeAndComeoutModel(
                                currency: currency.code,
                                date: selectedDateNotifier.value
                                    .toUtc()
                                    .toIso8601String(),
                                amount: amountController.text,
                                transactionType: transactionType,
                                account: selectedAccountId!,
                                description: descriptionController.text,
                                kgsCurrencyAmount: currency.code == 'kgs'
                                    ? amountController.text
                                    : null,
                                incomeExpenseReason: selectedReasonId!,
                              );
                              context.read<IncomeCubit>().addIncome(income);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary200Color,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              t.income.save, // "Сохранить" / "Save"
                              style: AppTextStyles.f16w500.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    return result;
  }

  void _showCustomDateTimePicker(
    BuildContext context,
    DateTime initialDateTime,
    void Function(DateTime) onDateTimeSelected,
  ) async {
    DateTime tempDate = initialDateTime;
    TimeOfDay tempTime = TimeOfDay.fromDateTime(tempDate);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: tempDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    onDateChanged: (date) => setState(() => tempDate = date),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.income.time,
                        style: AppTextStyles.f20w500,
                      ), // "Время" / "Time"
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: tempTime,
                          );
                          if (picked != null) {
                            setState(() {
                              tempTime = picked;
                            });
                          }
                        },
                        child: Text(
                          MaterialLocalizations.of(
                            context,
                          ).formatTimeOfDay(tempTime),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final newDateTime = DateTime(
                        tempDate.year,
                        tempDate.month,
                        tempDate.day,
                        tempTime.hour,
                        tempTime.minute,
                      );
                      onDateTimeSelected(newDateTime);
                      Navigator.pop(context);
                    },
                    child: Text(t.income.select), // "Выбрать" / "Select"
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCurrencyMenu(
    BuildContext context,
    GlobalKey iconKey,
    ValueNotifier<_CurrencyOption> selectedCurrency,
    List<_CurrencyOption> options,
  ) async {
    final RenderBox? button =
        iconKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (button == null || overlay == null) return;

    final position = button.localToGlobal(Offset.zero, ancestor: overlay);
    final rect = RelativeRect.fromLTRB(
      position.dx,
      position.dy + button.size.height,
      overlay.size.width - position.dx - button.size.width,
      overlay.size.height - position.dy,
    );

    final selected = await showMenu<_CurrencyOption>(
      context: context,
      position: rect,
      color: AppColors.whiteColor,
      items: options.map((option) {
        return PopupMenuItem<_CurrencyOption>(
          value: option,
          child: Text(option.label),
        );
      }).toList(),
    );

    if (selected != null) {
      selectedCurrency.value = selected;
    }
  }
}

class _CurrencyOption {
  const _CurrencyOption({required this.label, required this.code});

  final String label;
  final String code;
}
