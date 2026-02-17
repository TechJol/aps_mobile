// ignore_for_file: deprecated_member_use
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PeriodPickerBottomSheet extends StatefulWidget {
  const PeriodPickerBottomSheet({super.key, required this.filter});

  final OperationFilter filter;

  static Future<OperationFilter?> show(
    BuildContext context,
    OperationFilter filter,
  ) {
    return showModalBottomSheet<OperationFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PeriodPickerBottomSheet(filter: filter),
    );
  }

  @override
  State<PeriodPickerBottomSheet> createState() =>
      _PeriodPickerBottomSheetState();
}

class _PeriodPickerBottomSheetState extends State<PeriodPickerBottomSheet> {
  late String? _periodLabel;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _periodLabel = widget.filter.periodLabel;
    _startDate = widget.filter.startDate ?? DateTime.now();
    _endDate = widget.filter.endDate ?? DateTime.now();
  }

  bool get _datesEnabled => _periodLabel == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            16.h,
            Row(
              children: [
                _DatePreview(
                  label: t.operation.start,
                  date: _datesEnabled ? _startDate : null,
                  onTap: _datesEnabled ? _pickStartDate : null,
                ),
                const SizedBox(width: 10),
                _DatePreview(
                  label: t.operation.end,
                  date: _datesEnabled ? _endDate : null,
                  onTap: _datesEnabled ? _pickEndDate : null,
                ),
              ],
            ),
            20.h,
            _PeriodOption(
              label: t.operation.week,
              selected: _periodLabel,
              onChanged: _onPeriodChanged,
            ),
            _PeriodOption(
              label: t.operation.oneMonth,
              selected: _periodLabel,
              onChanged: _onPeriodChanged,
            ),
            _PeriodOption(
              label: t.operation.threeMonth,
              selected: _periodLabel,
              onChanged: _onPeriodChanged,
            ),
            20.h,
            ElevatedButton(
              onPressed: _submit,
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
            20.h,
          ],
        ),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _onPeriodChanged(String? label) {
    setState(() {
      _periodLabel = _periodLabel == label ? null : label;
      if (_periodLabel != null) {
        _startDate = null;
        _endDate = null;
      } else {
        _startDate ??= DateTime.now();
        _endDate ??= DateTime.now();
      }
    });
  }

  void _submit() {
    Navigator.pop(
      context,
      OperationFilter(
        periodLabel: _periodLabel,
        startDate: _periodLabel == null ? _startDate : null,
        endDate: _periodLabel == null ? _endDate : null,
      ),
    );
  }
}

class _DatePreview extends StatelessWidget {
  const _DatePreview({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: scheme.surfaceContainerHighest.withOpacity(
              onTap == null ? 0.6 : 1.0,
            ),
            border: Border.all(color: scheme.outlineVariant, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.f12w400),
                  2.h,
                  Text(
                    date == null
                        ? '—'
                        : '${date!.day.toString().padLeft(2, '0')}.${date!.month.toString().padLeft(2, '0')}.${date!.year}',
                    style: AppTextStyles.f14w500.copyWith(
                      color: date == null
                          ? scheme.onSurfaceVariant
                          : scheme.onSurface,
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
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isSelected = label == selected;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onChanged(isSelected ? null : label),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 55,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: scheme.outlineVariant, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.f16w500.copyWith(color: scheme.onSurface),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: scheme.onSurfaceVariant,
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: scheme.outlineVariant, width: 1),
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) =>
                        isSelected ? AppColors.primaryColor : scheme.surface,
                  ),
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
}
