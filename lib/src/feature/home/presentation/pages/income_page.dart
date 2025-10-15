// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeTransactionsPage extends StatefulWidget {
  const IncomeTransactionsPage({super.key});

  @override
  State<IncomeTransactionsPage> createState() => _IncomeTransactionsPageState();
}

class _IncomeTransactionsPageState extends State<IncomeTransactionsPage>
    with SingleTickerProviderStateMixin {
  OperationFilter _filter = const OperationFilter();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().getTransactionsWithAccounts();
    context.read<CredentialCubit>().getUserById();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openPeriodPicker() async {
    final selected = await PeriodPickerBottomSheet.show(context, _filter);
    if (selected != null && mounted) {
      setState(() => _filter = selected);
    }
  }

  void _resetFilter() {
    setState(() => _filter = const OperationFilter());
  }

  Future<void> _handleAddPartner(AllTransactionsModel transaction) async {
    final result = await AddPartnerBottomSheet.show(context, transaction);
    if (result == true && mounted) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterLabel = _filter.formattedLabel();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F7),
        title: Text(
          t.home.income,
          style: AppTextStyles.f24w600.copyWith(color: AppColors.primaryColor),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    AppRoutes.menu,
                  );
                  if (result == true && mounted) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          OperationFilterField(label: filterLabel, onTap: _openPeriodPicker),
          OperationFilterChip(label: filterLabel, onReset: _resetFilter),
          30.h,
          BlocConsumer<MenuCubit, MenuState>(
            listener: (context, state) {
              if (state is MenuTransactionUpdatedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.operation.partnerSuccessUpdate)),
                );
              }
              if (state is MenuError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${t.operation.error}: ${state.message}'),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is MenuLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is! MenuTransactionsWithAccountsSuccess) {
                return const SizedBox.shrink();
              }

              final incomes = state.transactions
                  .where((tx) => tx.transactionType == 'income')
                  .toList();

              if (incomes.isEmpty) {
                return Text(t.home.noOperations, style: AppTextStyles.f16w500);
              }

              final filtered = OperationTransactionsHelper.filterByRange(
                transactions: incomes,
                periodLabel: _filter.periodLabel,
                startDate: _filter.startDate,
                endDate: _filter.endDate,
                nowBuilder: DateTime.now,
                weekLabel: t.operation.week,
                oneMonthLabel: t.operation.oneMonth,
                threeMonthLabel: t.operation.threeMonth,
              );

              final groups = OperationTransactionsHelper.groupByDate(filtered)
                ..sort((a, b) => b.label.compareTo(a.label));

              return OperationTransactionList(
                groups: groups,
                partners: state.partners,
                controller: _controller,
                onRequestPartner: _handleAddPartner,
              );
            },
          ),
          20.h,
        ],
      ),
    );
  }
}
