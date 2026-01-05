import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:aps_mobile/src/feature/income/presentation/widgets/income_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final ValueNotifier<bool> isFormValidNotifier = ValueNotifier<bool>(false);
    final ValueNotifier<bool> showValidationErrors = ValueNotifier<bool>(false);
    final ValueNotifier<int> formStateVersionNotifier = ValueNotifier<int>(0);

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
    String? selectedPartnerTypeName;
    int? selectedPartnerTypeId;
    String? selectedPartnerName;
    int? selectedPartnerId;
    final ValueNotifier<bool> includePartnerNotifier = ValueNotifier<bool>(
      false,
    );

    void updateFormValidity() {
      final isValid =
          selectedAccountId != null &&
          selectedReasonId != null &&
          amountController.text.trim().isNotEmpty;

      if (isFormValidNotifier.value != isValid) {
        isFormValidNotifier.value = isValid;
      }

      if (showValidationErrors.value && isValid) {
        showValidationErrors.value = false;
      }

      formStateVersionNotifier.value++;
    }

    amountController.addListener(updateFormValidity);

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
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
                    const IncomeSheetHandle(),
                    IncomeSheetHeader(
                      title: title,
                      onClose: () => Navigator.pop(context),
                    ),
                    16.h,

                    IncomeDateField(
                      controller: dateController,
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
                    ),
                    12.h,

                    /// Dropdown: Account
                    BlocConsumer<IncomeCubit, IncomeState>(
                      listener: (context, state) {
                        if (state.error != null) {
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.clearSnackBars();
                          messenger.showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.35,
                              ),
                              content: Text(state.error!),
                            ),
                          );
                        }
                        if (state.incomeSaved) {
                          Navigator.pop(context, true);
                          context.read<IncomeCubit>().resetState();
                        }
                      },
                      builder: (context, state) {
                        if (state.isLoading && state.accounts.isEmpty) {
                          return const CircularProgressIndicator();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IncomeDropdownField(
                              items: state.accounts.map((e) => e.name).toList(),
                              label: t.income.account,
                              value: selectedAccountName,
                              placeholder: t.income.notAccount,

                              onChanged: (val) {
                                selectedAccountName = val;
                                selectedAccountId = state.accounts
                                    .firstWhere((e) => e.name == val)
                                    .id;
                                updateFormValidity();
                              },
                            ),
                            const SizedBox(height: 4),
                            IncomeValidationMessage(
                              showValidationErrors: showValidationErrors,
                              validationTrigger: formStateVersionNotifier,
                              isFieldValid: () => selectedAccountId != null,
                            ),
                          ],
                        );
                      },
                    ),
                    12.h,

                    ValueListenableBuilder<_CurrencyOption>(
                      valueListenable: selectedCurrency,
                      builder: (context, currency, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IncomeAmountField(
                            controller: amountController,
                            currencyLabel: currency.label,
                            onCurrencyTap: () => _showCurrencyMenu(
                              context,
                              currencyButtonKey,
                              selectedCurrency,
                              currencyOptions,
                            ),
                            currencyIcon: SizedBox(
                              height: 18,
                              width: 18,
                              child: Image.asset(
                                'assets/icons/currencies.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            currencyButtonKey: currencyButtonKey,
                          ),
                          const SizedBox(height: 4),
                          IncomeValidationMessage(
                            showValidationErrors: showValidationErrors,
                            validationTrigger: formStateVersionNotifier,
                            isFieldValid: () =>
                                amountController.text.trim().isNotEmpty,
                          ),
                        ],
                      ),
                    ),
                    12.h,

                    /// Dropdown: Reason
                    BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, state) {
                        if (state.isLoading && state.reasons.isEmpty) {
                          return const CircularProgressIndicator();
                        }

                        final filteredReasons = state.reasons
                            .where((e) => e.type == transactionType)
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IncomeDropdownField(
                              items: filteredReasons
                                  .map((e) => e.name)
                                  .toList(),
                              label: t.income.article,
                              value: selectedReasonName,
                              placeholder: t.income.notArticle,
                              onChanged: (val) {
                                selectedReasonName = val;
                                selectedReasonId = state.reasons
                                    .firstWhere((e) => e.name == val)
                                    .id;
                                updateFormValidity();
                              },
                            ),
                            const SizedBox(height: 4),
                            IncomeValidationMessage(
                              showValidationErrors: showValidationErrors,
                              validationTrigger: formStateVersionNotifier,
                              isFieldValid: () => selectedReasonId != null,
                            ),
                          ],
                        );
                      },
                    ),
                    12.h,

                    ValueListenableBuilder<bool>(
                      valueListenable: includePartnerNotifier,
                      builder: (context, includePartner, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: includePartner,
                                  side: BorderSide(
                                    color: AppColors.primary200Color,
                                  ),
                                  onChanged: (v) {
                                    includePartnerNotifier.value = v ?? false;
                                    if (!(v ?? false)) {
                                      selectedPartnerTypeName = null;
                                      selectedPartnerTypeId = null;
                                      selectedPartnerName = null;
                                      selectedPartnerId = null;
                                      updateFormValidity();
                                    }
                                    formStateVersionNotifier.value++;
                                  },
                                  visualDensity: VisualDensity.compact,
                                  activeColor: AppColors.primary200Color,
                                  checkColor: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  t.income.addPartner,
                                  style: AppTextStyles.f12w600.copyWith(
                                    color: AppColors.primary200Color,
                                  ),
                                ),
                              ],
                            ),
                            if (includePartner) ...[
                              12.h,

                              /// Dropdown: Partner type
                              BlocBuilder<IncomeCubit, IncomeState>(
                                builder: (context, state) {
                                  if (state.isLoading &&
                                      state.partnerTypes.isEmpty) {
                                    return const CircularProgressIndicator();
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IncomeDropdownField(
                                        items: state.partnerTypes
                                            .map((e) => e.name)
                                            .toList(),
                                        label: t.income.partnerType,
                                        value: selectedPartnerTypeName,
                                        placeholder: t.income.notPartnerType,
                                        onChanged: (val) {
                                          if (val == null) return;
                                          selectedPartnerTypeName = val;
                                          selectedPartnerTypeId = state
                                              .partnerTypes
                                              .firstWhere((e) => e.name == val)
                                              .id;
                                          selectedPartnerName = null;
                                          selectedPartnerId = null;
                                          updateFormValidity();
                                        },
                                      ),
                                      const SizedBox(height: 4),
                                      IncomeValidationMessage(
                                        showValidationErrors:
                                            showValidationErrors,
                                        validationTrigger:
                                            formStateVersionNotifier,
                                        isFieldValid: () => true,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              12.h,

                              /// Dropdown: Partner
                              BlocBuilder<IncomeCubit, IncomeState>(
                                builder: (context, state) {
                                  if (state.isLoading &&
                                      state.partners.isEmpty) {
                                    return const CircularProgressIndicator();
                                  }

                                  return ValueListenableBuilder<int>(
                                    valueListenable: formStateVersionNotifier,
                                    builder: (_, __, ___) {
                                      final partnersForType = state.partners
                                          .where(
                                            (partner) =>
                                                partner.type ==
                                                selectedPartnerTypeId,
                                          )
                                          .toList();

                                      if (selectedPartnerTypeId == null ||
                                          partnersForType.isEmpty) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IncomeDropdownField(
                                              items: const [],
                                              label: t.income.partner,
                                              value: selectedPartnerName,
                                              placeholder: t.income.notPartner,
                                              onChanged: null,
                                            ),
                                            const SizedBox(height: 4),
                                            IncomeValidationMessage(
                                              showValidationErrors:
                                                  showValidationErrors,
                                              validationTrigger:
                                                  formStateVersionNotifier,
                                              isFieldValid: () => true,
                                            ),
                                          ],
                                        );
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IncomeDropdownField(
                                            items: partnersForType
                                                .map((e) => e.name)
                                                .toList(),
                                            label: t.income.partner,
                                            value: selectedPartnerName,
                                            placeholder: t.income.notPartner,
                                            onChanged: (val) {
                                              selectedPartnerName = val;
                                              selectedPartnerId =
                                                  partnersForType
                                                      .firstWhere(
                                                        (e) => e.name == val,
                                                      )
                                                      .id;
                                              updateFormValidity();
                                            },
                                          ),
                                          const SizedBox(height: 4),
                                          IncomeValidationMessage(
                                            showValidationErrors:
                                                showValidationErrors,
                                            validationTrigger:
                                                formStateVersionNotifier,
                                            isFieldValid: () => true,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ],
                        );
                      },
                    ),

                    24.h,

                    IncomeDescriptionField(controller: descriptionController),
                    24.h,

                    /// Save button
                    BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const CircularProgressIndicator();
                        }

                        return ValueListenableBuilder<bool>(
                          valueListenable: isFormValidNotifier,
                          builder: (context, isFormValid, _) {
                            return ElevatedButton(
                              onPressed: () {
                                if (!isFormValid) {
                                  showValidationErrors.value = true;
                                  formStateVersionNotifier.value++;
                                  return;
                                }

                                final currency = selectedCurrency.value;
                                final income = IncomeAndComeoutModel(
                                  currency: currency.code,
                                  date: selectedDateNotifier.value
                                      .toIso8601String(),
                                  amount: amountController.text,
                                  transactionType: transactionType,
                                  account: selectedAccountId!,
                                  description: descriptionController.text,
                                  kgsCurrencyAmount: currency.code == 'kgs'
                                      ? amountController.text
                                      : null,
                                  incomeExpenseReason: selectedReasonId!,
                                  partner: null,
                                  partners: selectedPartnerId,
                                );
                                context.read<IncomeCubit>().addIncome(income);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFormValid
                                    ? AppColors.primary200Color
                                    : AppColors.greyColorLight,
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
                  16.h,
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
                  16.h,
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
