import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuAccountsPage extends StatefulWidget {
  const MenuAccountsPage({super.key});

  @override
  State<MenuAccountsPage> createState() => _MenuAccountsPageState();
}

class _MenuAccountsPageState extends State<MenuAccountsPage> {
  final LocalService _localService = LocalService();
  late final Future<Map<String, double>> _ratesFuture;

  static const int _rowsPerPage = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    final state = context.read<MenuCubit>().state;
    if (state is! MenuTransactionsWithAccountsSuccess) {
      context.read<MenuCubit>().getTransactionsWithAccounts();
    }
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
      return rates.map((key, value) => MapEntry(key.toUpperCase(), value));
    } catch (_) {
      return const {'KGS': 1.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: t.menu.operationsByAccounts,
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenuError) {
            return Center(child: Text('${t.menu.error}: ${state.message}'));
          }
          if (state is! MenuTransactionsWithAccountsSuccess) {
            return const SizedBox.shrink();
          }

          final transactions = state.transactions;
          final accounts = state.accounts;

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

              final calculator = AccountReportCalculator(rates: rates);
              final summary = calculator.build(
                accounts: accounts,
                transactions: transactions,
              );

              final pageCount = summary.rows.isEmpty
                  ? 1
                  : (summary.rows.length / _rowsPerPage).ceil();
              if (_currentPage > pageCount && pageCount > 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _currentPage = pageCount);
                });
              }

              final headers = [
                t.menu.common.numberSign,
                t.menu.accounts.headers.name,
                t.menu.accounts.headers.balance,
                t.menu.accounts.headers.accountType,
              ];

              return AccountsReportView(
                summary: summary,
                rowsPerPage: _rowsPerPage,
                currentPage: _currentPage,
                onPageChanged: (page) => setState(() => _currentPage = page),
                onPrint: (rows) => _printReport(context, headers, rows),
                onExport: (rows) => _exportReport(context, headers, rows),
              );
            },
          );
        },
      ),
    );
  }

  void _printReport(
    BuildContext context,
    List<String> headers,
    List<List<String>> rows,
  ) {
    _localService.printReportAsPdf(
      context: context,
      title: t.menu.accounts.printTitle,
      headers: headers,
      rows: rows,
    );
  }

  void _exportReport(
    BuildContext context,
    List<String> headers,
    List<List<String>> rows,
  ) {
    _localService.exportToExcelGeneric(
      fileName: t.menu.accounts.fileName,
      headers: headers,
      rows: rows,
      context: context,
    );
  }
}
