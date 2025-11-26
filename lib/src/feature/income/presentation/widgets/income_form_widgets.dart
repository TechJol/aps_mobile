import 'package:aps_mobile/src/core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IncomeSheetHandle extends StatelessWidget {
  const IncomeSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class IncomeSheetHeader extends StatelessWidget {
  const IncomeSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
      ],
    );
  }
}

class IncomeDateField extends StatelessWidget {
  const IncomeDateField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        labelStyle: AppTextStyles.f16w500,
        fillColor: AppColors.backroundColor,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 24,
              child: SvgPicture.asset(
                'assets/icons/calendar.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.backroundColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: AppColors.backroundColor),
        ),
      ),
    );
  }
}

class IncomeDropdownField extends StatelessWidget {
  const IncomeDropdownField({
    super.key,
    required this.items,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  final List<String> items;
  final String label;
  final String? value;
  final String placeholder;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return DropDownFormField(
        items: const [],
        label: label,
        value: placeholder,
        onChanged: (_) {},
      );
    }

    return DropDownFormField(
      items: items,
      label: label,
      value: value,
      onChanged: onChanged!,
    );
  }
}

class IncomeAmountField extends StatelessWidget {
  const IncomeAmountField({
    super.key,
    required this.controller,
    required this.currencyLabel,
    required this.onCurrencyTap,
    required this.currencyIcon,
    required this.currencyButtonKey,
  });

  final TextEditingController controller;
  final String currencyLabel;
  final VoidCallback onCurrencyTap;
  final Widget currencyIcon;
  final GlobalKey currencyButtonKey;

  @override
  Widget build(BuildContext context) {
    return TextFieldWid(
      label: t.income.sum,
      controller: controller,
      suffixIcon: GestureDetector(
        key: currencyButtonKey,
        onTap: onCurrencyTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              currencyIcon,
              const SizedBox(width: 6),
              Text(
                currencyLabel,
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
    );
  }
}

class IncomeDescriptionField extends StatelessWidget {
  const IncomeDescriptionField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 160,
      maxLines: 3,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        labelStyle: AppTextStyles.f16w500,
        fillColor: AppColors.backroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        hintText: t.income.description,
      ),
    );
  }
}

class IncomeValidationMessage extends StatelessWidget {
  const IncomeValidationMessage({
    super.key,
    required this.showValidationErrors,
    required this.validationTrigger,
    required this.isFieldValid,
  });

  final ValueListenable<bool> showValidationErrors;
  final ValueListenable<int> validationTrigger;
  final bool Function() isFieldValid;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showValidationErrors,
      builder: (_, showErrors, __) {
        if (!showErrors) return const SizedBox.shrink();
        return ValueListenableBuilder<int>(
          valueListenable: validationTrigger,
          builder: (_, __, ___) {
            if (isFieldValid()) return const SizedBox.shrink();
            return Text(
              t.income.pleaseFillInAllFields,
              style: AppTextStyles.f14w500.copyWith(color: AppColors.redColor),
            );
          },
        );
      },
    );
  }
}
