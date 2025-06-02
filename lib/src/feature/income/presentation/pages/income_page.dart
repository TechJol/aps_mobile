import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class IncomePage {
  void showIncomeBottomSheet({
    required BuildContext context,
    required String title,
  }) {
    DateTime selectedDateTime = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
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
                          controller: TextEditingController(
                            text: DateFormat(
                              'dd.MM.yyyy – HH:mm',
                            ).format(selectedDateTime),
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            labelStyle: AppTextStyles.f16w500,
                            fillColor: AppColors.backroundColor,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _showCustomDateTimePicker(
                                  context,
                                  selectedDateTime,
                                  (picked) {
                                    selectedDateTime = picked;
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

                            // hintText: formattedDate,
                            // labelText: label,
                          ),
                        ),

                        12.h,

                        DropDownFormField(
                          items: ['Пример 1', 'Пример 2'],
                          label: 'Счет',
                          value: 'Счет',
                          onChanged: (val) {},
                        ),
                        const SizedBox(height: 12),
                        TextFieldWid(label: 'Сумма'),
                        const SizedBox(height: 12),
                        DropDownFormField(
                          items: ['Пример 1', 'Пример 2'],
                          label: 'Статья',
                          value: 'Статья',
                          onChanged: (val) {},
                        ),

                        12.h,

                        TextFormField(
                          maxLength: 160,
                          maxLines: 3,
                          // controller: controller,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            // labelText: 'Описание',
                          ),
                        ),

                        24.h,

                        ElevatedButton(
                          onPressed: () {},
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
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColorLight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          tempTime.format(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary200Color,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
                    child: Text(
                      "Выбрать",
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
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
