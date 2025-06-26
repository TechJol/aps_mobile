class AllTransactionsModel {
  final int? id;
  final String? currency;
  final String? date;
  final String? amount;
  final String? kgsCurrencyAmount;
  final String? transactionType;
  final String? description;
  final int? company;
  final int? account;
  final int? partner;
  final int? partners;
  final int? incomeExpenseReason;

  AllTransactionsModel({
    this.id,
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
    required this.incomeExpenseReason,
  });

  // Метод copyWith
  AllTransactionsModel copyWith({
    int? id,
    String? currency,
    String? date,
    String? amount,
    String? kgsCurrencyAmount,
    String? transactionType,
    String? description,
    int? company,
    int? account,
    int? partner,
    int? partners,
    int? incomeExpenseReason,
  }) {
    return AllTransactionsModel(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      kgsCurrencyAmount: kgsCurrencyAmount ?? this.kgsCurrencyAmount,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      company: company ?? this.company,
      account: account ?? this.account,
      partner: partner ?? this.partner,
      partners: partners ?? this.partners,
      incomeExpenseReason: incomeExpenseReason ?? this.incomeExpenseReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currency': currency,
      'date': date,
      'amount': amount,
      'kgs_currency_amount': kgsCurrencyAmount,
      'transaction_type': transactionType,
      'description': description,
      'company': company,
      'account': account,
      'partner': partner,
      'partners': partners,
      'income_expense_reason': incomeExpenseReason,
    };
  }

  factory AllTransactionsModel.fromMap(Map<String, dynamic> map) {
    return AllTransactionsModel(
      id: map['id'],
      currency: map['currency'],
      date: map['date'],
      amount: map['amount'],
      kgsCurrencyAmount: map['kgs_currency_amount'],
      transactionType: map['transaction_type'],
      description: map['description'],
      company: map['company'],
      account: map['account'],
      partner: map['partner'],
      partners: map['partners'],
      incomeExpenseReason: map['income_expense_reason'],
    );
  }
}
