import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final MenuTransactionsWithAccountsSuccess? data;
  final PeriodType selectedPeriod;
  final List<PeriodType> periodOptions;
  final void Function(PeriodType) onPeriodTap;
  final void Function(bool forward) onPeriodChange;
  final ViewType selectedView;
  final ValueChanged<ViewType> onViewChanged;

  const HomeHeader({
    super.key,
    required this.data,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodTap,
    required this.onPeriodChange,
    required this.selectedView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F7),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          TopSection(
            data: data,
            selectedPeriod: selectedPeriod,
            periodOptions: periodOptions,
            periodLabel: (period) => _periodLabel(context, period),
            onPeriodTap: onPeriodTap,
            onPeriodChange: onPeriodChange,
          ),
          const SizedBox(height: 15),
          OperationFilters(
            selectedView: selectedView,
            onChanged: onViewChanged,
          ),
        ],
      ),
    );
  }

  String _periodLabel(BuildContext context, PeriodType period) {
    switch (period) {
      case PeriodType.day:
        return t.home.day;
      case PeriodType.week:
        return t.home.week;
      case PeriodType.month:
        return t.home.month;
      case PeriodType.year:
        return t.home.year;
    }
  }
}
