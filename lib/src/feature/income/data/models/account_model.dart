class AccountModel {
  AccountModel({
    required this.id,
    required this.name,
    required this.accountType,
    required this.currency,
    required this.company,
  });

  final int id;
  final String name;
  final String accountType;
  final String currency;
  final int company;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'account_type': accountType,
      'currency': currency,
      'company': company,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int,
      name: map['name'] as String,
      accountType: map['account_type'] as String,
      currency: map['currency'] as String,
      company: map['company'] as int,
    );
  }
}
