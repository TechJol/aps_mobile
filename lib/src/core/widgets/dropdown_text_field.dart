// ignore_for_file: deprecated_member_use

import 'package:aps_mobile/src/core/core.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownFormField extends StatelessWidget {
  const DropDownFormField({
    super.key,
    required this.items,
    required this.label,
    required this.value,
    required this.onChanged,
    this.isSettingDropdown = true,
  });

  final List<String> items;
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool isSettingDropdown;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: value,
      onChanged: onChanged,
      items: (f, cs) => items,

      dropdownBuilder: (context, selectedItem) =>
          Text(selectedItem ?? '', style: AppTextStyles.f16w500),

      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: const Icon(Icons.keyboard_arrow_down_outlined),
          iconOpened: const Icon(Icons.keyboard_arrow_up_outlined),
        ),
      ),

      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          label: Text(label, style: AppTextStyles.f16w500),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: AppColors.backroundColor,
          filled: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            // borderSide: const BorderSide(width: 1, color: AppColors.blackColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              width: 0.5,
              color: isSettingDropdown == false
                  ? AppColors.blackColor
                  : AppColors.transparentColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.primary200Color,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),

      popupProps: PopupProps.menu(
        showSelectedItems: true,
        fit: FlexFit.loose,

        constraints: const BoxConstraints(maxHeight: 320),

        itemClickProps: ClickProps(
          splashColor: AppColors.primaryColor.withOpacity(0.3),
        ),

        itemBuilder:
            (
              BuildContext context,
              String item,
              bool isSelected,
              bool isHovered,
            ) {
              return Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary200Color.withOpacity(0.5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Text(
                  item,
                  style: AppTextStyles.f16w500.copyWith(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackColor,
                  ),
                ),
              );
            },

        listViewProps: const ListViewProps(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
        ),

        menuProps: MenuProps(
          backgroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          elevation: 8,
          shadowColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
