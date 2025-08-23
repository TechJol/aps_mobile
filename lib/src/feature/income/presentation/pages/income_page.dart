import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/feature/income/presentation/cubit/income_state.dart';
import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart'; // <— t.*
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
      builder:
          (context) => BlocListener<IncomeCubit, IncomeState>(
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
                                  value:
                                      t
                                          .income
                                          .notAccount, // "Нет счетов.." / "No accounts.."
                                  onChanged: (_) {},
                                );
                              }

                              return DropDownFormField(
                                items:
                                    state.accounts.map((e) => e.name).toList(),
                                label: t.income.account,
                                value: selectedAccountName,
                                onChanged: (val) {
                                  selectedAccountName = val;
                                  selectedAccountId =
                                      state.accounts
                                          .firstWhere((e) => e.name == val)
                                          .id;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Сумма
                          TextFieldWid(
                            label: t.income.sum, // "Сумма" / "Sum"
                            controller: amountController,
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
                                  label:
                                      t.income.article, // "Статья" / "Article"
                                  value:
                                      t
                                          .income
                                          .notArticle, // "Нет статей.." / "No articles.."
                                  onChanged: (_) {},
                                );
                              }

                              final filteredReasons =
                                  state.reasons
                                      .where((e) => e.type == transactionType)
                                      .toList();

                              return DropDownFormField(
                                items:
                                    filteredReasons.map((e) => e.name).toList(),
                                label: t.income.article,
                                value: selectedReasonName,
                                onChanged: (val) {
                                  selectedReasonName = val;
                                  selectedReasonId =
                                      state.reasons
                                          .firstWhere((e) => e.name == val)
                                          .id;
                                },
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
                              hintText:
                                  t
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

                                  final income = IncomeAndComeoutModel(
                                    currency: 'kgs',
                                    date:
                                        selectedDateNotifier.value
                                            .toUtc()
                                            .toIso8601String(),
                                    amount: amountController.text,
                                    transactionType: transactionType,
                                    account: selectedAccountId!,
                                    description: descriptionController.text,
                                    kgsCurrencyAmount: "1",
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
}
