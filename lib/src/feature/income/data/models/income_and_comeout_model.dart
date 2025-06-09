import 'package:aps_mobile/src/feature/feature.dart';

class IncomeAndComeoutModel extends IncomeAndComeoutEntity {
  IncomeAndComeoutModel({
    required super.currency,
    required super.date,
    required super.amount,
    required super.transactionType,
    required super.company,
    required super.account,
    super.description,
    super.kgsCurrencyAmount,
    super.incomeExpenseReason,
    super.partner,
    super.partners,
  });

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
