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
    required this.id, //
    required this.currency, //
    required this.date, //
    required this.amount, //
    this.kgsCurrencyAmount,
    required this.transactionType, //
    required this.description, //
    this.company,
    required this.account, //
    required this.partner, //
    this.partners,
    required this.incomeExpenseReason, //
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'currency': currency,
      'date': date,
      'amount': amount,
      'kgsCurrencyAmount': kgsCurrencyAmount,
      'transactionType': transactionType,
      'description': description,
      'company': company,
      'account': account,
      'partner': partner,
      'partners': partners,
      'incomeExpenseReason': incomeExpenseReason,
    };
  }

  factory AllTransactionsModel.fromMap(Map<String, dynamic> map) {
    return AllTransactionsModel(
      id: map['id'] != null ? map['id'] as int : null,
      currency: map['currency'] != null ? map['currency'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      kgsCurrencyAmount:
          map['kgsCurrencyAmount'] != null
              ? map['kgsCurrencyAmount'] as String
              : null,
      transactionType:
          map['transactionType'] != null
              ? map['transactionType'] as String
              : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      company: map['company'] != null ? map['company'] as int : null,
      account: map['account'] != null ? map['account'] as int : null,
      partner: map['partner'] != null ? map['partner'] as int : null,
      partners: map['partners'] != null ? map['partners'] as int : null,
      incomeExpenseReason:
          map['incomeExpenseReason'] != null
              ? map['incomeExpenseReason'] as int
              : null,
    );
  }
}
