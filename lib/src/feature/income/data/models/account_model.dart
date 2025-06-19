class AccountModel {
  AccountModel({
    this.id,
    required this.name,
    required this.accountType,
    this.currency,
    this.currentBalance,
    this.company,
  });

  final int? id;
  final String name;
  final String accountType;
  final String? currency;
  final String? currentBalance;
  final int? company;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'account_type': accountType,
      'currency': currency,
      'current_balance': currentBalance,
      'company': company,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      accountType: map['account_type'] as String,
      currency: map['currency'] != null ? map['currency'] as String : null,
      currentBalance:
          map['current_balance'] != null
              ? map['current_balance'] as String
              : null,
      company: map['company'] != null ? map['company'] as int : null,
    );
  }
}
