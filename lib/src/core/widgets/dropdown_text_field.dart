import 'package:aps_mobile/src/core/core.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownFormField extends StatelessWidget {
  const DropDownFormField({
    super.key,
    required this.items,
    required this.label,
  });

  final List<String> items;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (f, cs) => items,
      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: Icon(Icons.keyboard_arrow_down_outlined),
          iconOpened: Icon(Icons.keyboard_arrow_up_outlined),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          label: Text(label, style: AppTextStyles.f16w500),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: AppColors.backroundColor,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.backroundColor),
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
        listViewProps: ListViewProps(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
        ),
        menuProps: MenuProps(
          backgroundColor: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          elevation: 8,

          shadowColor: AppColors.whiteColor,
        ),

        disabledItemFn: (item) => item == 'Item 3',
        fit: FlexFit.loose,
      ),
    );
  }
}
