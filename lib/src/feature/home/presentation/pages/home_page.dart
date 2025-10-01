// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ViewType selectedView = ViewType.all;
  PeriodType selectedPeriod = PeriodType.day;

  static const _periodOptionsOrder = [
    PeriodType.day,
    PeriodType.week,
    PeriodType.month,
    PeriodType.year,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
      context.read<CredentialCubit>().getUserById();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = context.watch<MenuCubit>().state;
    final transactionsState =
        menuState is MenuTransactionsWithAccountsSuccess ? menuState : null;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F7),
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/icons/logo_softkg.png'),
            ),
            Text(
              t.home.appbar,
              style: AppTextStyles.f24w600.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
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
                  if (result == true) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          HomeHeader(
            data: transactionsState,
            selectedPeriod: selectedPeriod,
            periodOptions: _periodOptionsOrder,
            onPeriodTap: _handlePeriodTap,
            onPeriodChange: _changePeriod,
            selectedView: selectedView,
            onViewChanged: _handleViewChange,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RecentOperationsSection(selectedView: selectedView),
          ),
        ],
      ),
    );
  }

  void _handleViewChange(ViewType view) {
    if (view == selectedView) return;
    setState(() => selectedView = view);
  }

  void _handlePeriodTap(PeriodType newPeriod) {
    if (newPeriod == selectedPeriod) return;
    setState(() => selectedPeriod = newPeriod);
  }

  void _changePeriod(bool forward) {
    final index = _periodOptionsOrder.indexOf(selectedPeriod);
    final nextIndex =
        forward
            ? (index + 1) % _periodOptionsOrder.length
            : (index - 1 + _periodOptionsOrder.length) %
                _periodOptionsOrder.length;
    _handlePeriodTap(_periodOptionsOrder[nextIndex]);
  }
}
