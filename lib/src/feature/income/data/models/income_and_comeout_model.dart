class IncomeAndComeoutModel {
  IncomeAndComeoutModel({
    required this.currency,
    required this.date,
    required this.amount,
    required this.kgsCurrencyAmount,
    required this.transactionType,
    required this.description,
    required this.company,
    required this.account,
    required this.partner,
    required this.partners,
    required this.incomeExpenseReason,
  });

  final String currency;
  final String date;
  final String amount;
  final String? kgsCurrencyAmount;
  final String transactionType;
  final String? description;
  final int? company;
  final int account;
  final int? partner;
  final int? partners;
  final int? incomeExpenseReason;

  factory IncomeAndComeoutModel.fromJson(Map<String, dynamic> json) {
    return IncomeAndComeoutModel(
      currency: json['currency'],
      date: json['date'],
      amount: json['amount'],
      transactionType: json['transaction_type'],
      company: json['company'],
      account: json['account'],
      description: json['description'],
      kgsCurrencyAmount: json['kgs_currency_amount'],
      incomeExpenseReason: json['income_expense_reason'],
      partner: json['partner'],
      partners: json['partners'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'date': date,
      'amount': amount,
      'transaction_type': transactionType,
      'company': company,
      'account': account,
      'description': description,
      'kgs_currency_amount': kgsCurrencyAmount,
      'income_expense_reason': incomeExpenseReason,
      'partner': partner,
      'partners': partners,
    };
  }
}
