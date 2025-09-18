// ignore_for_file: use_build_context_synchronously

import 'package:aps_mobile/src/core/I10n/generated/strings.g.dart';
import 'package:aps_mobile/src/core/core.dart';
import 'package:aps_mobile/src/feature/feature.dart';
import 'package:aps_mobile/src/core/utils/currency_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MainAccountPage extends StatefulWidget {
  const MainAccountPage({super.key});

  @override
  State<MainAccountPage> createState() => _MainAccountPageState();
}

class _MainAccountPageState extends State<MainAccountPage> {
  late final Future<Map<String, double>> _ratesFuture;

  @override
  void initState() {
    context.read<MenuCubit>().getTransactionsWithAccounts();
    _ratesFuture = _loadRates();
    super.initState();
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
            final transactions = state.transactions;
            final accounts = state.accounts;

            final totalsByCurrency = _calculateTotalsByCurrency(transactions);
            for (final account in accounts) {
              final code = (account.currency ?? 'KGS').toUpperCase();
              totalsByCurrency.putIfAbsent(code, () => Decimal.zero);
            }

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

                final totalBalance = calculateTotalBalance(transactions, rates);

                return _buildAccountSection(
                  context,
                  accounts,
                  totalBalance,
                  transactions,
                  totalsByCurrency,
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Padding _buildAccountSection(
    BuildContext context,
    List<AccountModel> data,
    Decimal total,
    List<AllTransactionsModel> transactions,
    Map<String, Decimal> totalsByCurrency, {
    bool isLoading = false,
  }) {
    final hasAccount = data.isNotEmpty;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final formatter = NumberFormat.currency(
      locale: localeTag,
      symbol: '',
      decimalDigits: 2,
    );

    String formatKgs(Decimal value) {
      final doubleVal = double.tryParse(value.toString()) ?? 0.0;
      return formatNumericAmountWithCurrency(
        doubleVal,
        'KGS',
        formatter: formatter,
      );
    }

    String formatOriginal(Decimal value, String? currency) {
      final doubleVal = double.tryParse(value.toString()) ?? 0.0;
      return formatNumericAmountWithCurrency(
        doubleVal,
        currency,
        formatter: formatter,
      );
    }

    final currencyOrder = ['KGS', 'USD', 'EUR', 'RUB'];
    final breakdownKeys = {
      ...currencyOrder,
      ...totalsByCurrency.keys.map((e) => e.toUpperCase()),
    };

    final sortedKeys =
        breakdownKeys.toList()..sort((a, b) {
          final ia = currencyOrder.indexOf(a);
          final ib = currencyOrder.indexOf(b);
          if (ia != -1 && ib != -1) return ia.compareTo(ib);
          if (ia != -1) return -1;
          if (ib != -1) return 1;
          return a.compareTo(b);
        });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      formatKgs(total),
                      style: AppTextStyles.f24w600.copyWith(
                        fontFamily: 'Inter',
                      ),
                    ),
                  Text(
                    t.account.totalBalances,
                    style: AppTextStyles.f14w500.copyWith(
                      color: AppColors.greyColor,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 48),
                ),
                onPressed: () async {
                  await Navigator.pushNamed(context, AppRoutes.account);
                  context.read<MenuCubit>().getTransactionsWithAccounts();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.account.addAccount,
                      style: AppTextStyles.f16w500.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (sortedKeys.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    sortedKeys.map((code) {
                      final amount =
                          totalsByCurrency[code.toUpperCase()] ?? Decimal.zero;
                      final formatted = formatOriginal(amount, code);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              code.toUpperCase(),
                              style: AppTextStyles.f14w500.copyWith(
                                color: AppColors.greyColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              formatted,
                              style: AppTextStyles.f16w600.copyWith(
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          const SizedBox(height: 24),
          if (hasAccount)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final account = data[index];
                final gradientColors =
                    index.isEven
                        ? [
                          const Color(0xFF783BE0),
                          const Color(0xFF8657F5),
                          const Color(0xFF492BAB),
                          const Color(0xFF462BA0),
                          const Color(0xFF27175A),
                        ]
                        : [
                          const Color.fromARGB(255, 6, 34, 105),
                          const Color(0xFF0A0AC8),
                          const Color(0xFF0A0AC8),
                          const Color.fromARGB(255, 25, 25, 185),
                          const Color.fromARGB(255, 11, 29, 117),
                        ];

                final originalBalance = calculateAccountBalanceOriginal(
                  accountId: account.id!,
                  transactions: transactions,
                );

                return CardWidget(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.moreinfo,
                      arguments: account,
                    );
                  },
                  price: formatOriginal(originalBalance, account.currency),
                  office: account.name,
                  cardColor: gradientColors,
                  currency: (account.currency ?? 'KGS').toUpperCase(),
                );
              },
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  t.account.account.errors.accountNotFound,
                  style: AppTextStyles.f16w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Decimal calculateTotalBalance(
    List<AllTransactionsModel> transactions,
    Map<String, double> rates,
  ) {
    Decimal total = Decimal.zero;

    for (final tx in transactions) {
      final amount = _amountInKgs(tx, rates);
      if (tx.transactionType == 'income') {
        total += amount;
      } else if (tx.transactionType == 'expense') {
        total -= amount;
      }
    }

    return total;
  }

  Decimal calculateAccountBalanceOriginal({
    required int accountId,
    required List<AllTransactionsModel> transactions,
  }) {
    Decimal total = Decimal.zero;

    for (final tx in transactions) {
      if (tx.account == accountId) {
        final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;
        if (tx.transactionType == 'income') {
          total += amount;
        } else if (tx.transactionType == 'expense') {
          total -= amount;
        }
      }
    }

    return total;
  }

  Map<String, Decimal> _calculateTotalsByCurrency(
    List<AllTransactionsModel> transactions,
  ) {
    final Map<String, Decimal> totals = {'KGS': Decimal.zero};

    for (final tx in transactions) {
      final code = (tx.currency ?? 'KGS').toUpperCase();
      final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

      totals.putIfAbsent(code, () => Decimal.zero);

      if (tx.transactionType == 'income') {
        totals[code] = totals[code]! + amount;
      } else if (tx.transactionType == 'expense') {
        totals[code] = totals[code]! - amount;
      }
    }

    return totals;
  }

  Decimal _amountInKgs(AllTransactionsModel tx, Map<String, double> rates) {
    final currency = (tx.currency ?? 'KGS').toUpperCase();
    final amount = Decimal.tryParse(tx.amount ?? '0') ?? Decimal.zero;

    if (currency == 'KGS') {
      return amount;
    }

    final kgsAmountStr = tx.kgsCurrencyAmount;
    if (kgsAmountStr != null && kgsAmountStr.trim().isNotEmpty) {
      return Decimal.tryParse(kgsAmountStr) ?? amount;
    }

    final rate = rates[currency];
    if (rate == null || rate == 0) {
      return amount;
    }

    return amount * Decimal.parse(rate.toString());
  }
}
