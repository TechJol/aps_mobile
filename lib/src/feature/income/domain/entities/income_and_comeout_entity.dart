class IncomeAndComeoutEntity {
  final String currency;
  final String date;
  final String amount;
  final int? kgsCurrencyAmount;
  final String transactionType;
  final String? description;
  final int? company;
  final int account;
  final int? partner;
  final int? partners;
  final int? incomeExpenseReason;

  IncomeAndComeoutEntity({
    required this.currency,
    required this.date,
    required this.amount,
    this.kgsCurrencyAmount,
    required this.transactionType,
    this.description,
    this.company,
    required this.account,
    this.partner,
    this.partners,
    this.incomeExpenseReason,
  });
}
