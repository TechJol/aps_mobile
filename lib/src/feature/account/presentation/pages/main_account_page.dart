// ignore_for_file: use_build_context_synchronously
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainAccountPage extends StatefulWidget {
  const MainAccountPage({super.key});

  @override
  State<MainAccountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  late final Future<Map<String, double>> _ratesFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuCubit>().getTransactionsWithAccounts();
    });
    _ratesFuture = _loadRates();
  }

  Future<Map<String, double>> _loadRates() async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final service = NbkrRatesService(dio);
      final rates = await service.fetchRates();
      return {
        for (final entry in rates.entries) entry.key.toUpperCase(): entry.value,
      };
    } catch (_) {
      return const {'KGS': 1.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            t.account.accountManagement,
            style: AppTextStyles.f24w600.copyWith(fontFamily: 'Inter'),
          ),
        ),
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
                  if (!mounted) return;
                  if (result == true) {
                    context.read<MenuCubit>().getTransactionsWithAccounts();
                  }
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          if (state is MenuTransactionsWithAccountsSuccess) {
            final accounts = state.accounts;
            final transactions = state.transactions;

            return FutureBuilder<Map<String, double>>(
              future: _ratesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final rates = (snapshot.data ?? const {'KGS': 1.0}).map(
                  (key, value) => MapEntry(key.toUpperCase(), value),
                );

                final calculator = AccountBalanceCalculator(rates: rates);
                final summary = calculator.summary(
                  accounts: accounts,
                  transactions: transactions,
                );

                return AccountOverviewView(
                  summary: summary,
                  isRatesLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  onAddAccount: () async {
                    final menuCubit = context.read<MenuCubit>();
                    await Navigator.pushNamed(context, AppRoutes.account);
                    if (!mounted) return;
                    menuCubit.getTransactionsWithAccounts();
                  },
                  onOpenAccount:
                      (account) => Navigator.pushNamed(
                        context,
                        AppRoutes.moreinfo,
                        arguments: account,
                      ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
