import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class IncomePage {
  void showIncomeBottomSheet({
    required BuildContext context,
    required String title,
    required String transactionType,
  }) {
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => BlocListener<IncomeCubit, IncomeState>(
            listener: (context, state) {
              if (state is IncomeSuccess) {
                Navigator.pop(context);
              }
              if (state is IncomeError) {
                var snackBar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              40.w,
                              Center(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          16.h,
                          TextFormField(
                            readOnly: true,
                            controller: dateController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                                  width: 1,
                                  color: AppColors.backroundColor,
                                ),
                              ),
                            ),
                          ),
                          12.h,
                          BlocBuilder<IncomeCubit, IncomeState>(
                            builder: (context, state) {
                              if (state is AccountLoaded) {
                                final accountItems = state.accounts;
                                return DropDownFormField(
                                  items:
                                      accountItems.map((e) => e.name).toList(),
                                  label: 'Счет',
                                  value: selectedAccountName,
                                  onChanged: (val) {
                                    selectedAccountName = val;
                                    selectedAccountId =
                                        accountItems
                                            .firstWhere(
                                              (element) => element.name == val,
                                            )
                                            .id;
                                  },
                                );
                              } else if (state is IncomeLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return DropDownFormField(
                                  items: [],
                                  label: 'Счет',
                                  value: 'Нет данных...',
                                  onChanged: (_) {},
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFieldWid(
                            label: 'Сумма',
                            controller: amountController,
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<IncomeCubit, IncomeState>(
                            builder: (context, state) {
                              if (state is IncomeExpenseReasonsLoaded) {
                                final reasons = state.reasons;
                                return DropDownFormField(
                                  items: reasons.map((e) => e.name).toList(),
                                  label: 'Статья',
                                  value: selectedReasonName,
                                  onChanged: (val) {
                                    selectedReasonName = val;
                                    selectedReasonId =
                                        reasons
                                            .firstWhere(
                                              (element) => element.name == val,
                                            )
                                            .id;
                                  },
                                );
                              } else if (state is IncomeLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return DropDownFormField(
                                  items: [],
                                  label: 'Статья',
                                  value: 'Нет данных...',
                                  onChanged: (_) {},
                                );
                              }
                            },
                          ),
                          12.h,
                          TextFormField(
                            maxLength: 160,
                            maxLines: 3,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              filled: true,
                              labelStyle: AppTextStyles.f16w500,
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
                              hintText: 'Описание',
                            ),
                          ),
                          24.h,
                          BlocBuilder<IncomeCubit, IncomeState>(
                            builder: (context, state) {
                              if (state is IncomeLoading) {
                                return const CircularProgressIndicator();
                              }
                              return ElevatedButton(
                                onPressed: () {
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
                                    partner: 1,
                                    partners: 1,
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
                                  'Сохранить',
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
                      const Text('Время', style: AppTextStyles.f20w500),
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
                        child: Text(tempTime.format(context)),
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
                    child: Text("Выбрать"),
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
