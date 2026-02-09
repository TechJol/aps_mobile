import 'package:aps_mobile/src/feature/feature.dart';

class MenuCacheSnapshot {
  final List<AllTransactionsModel> transactions;
  final List<AccountModel> accounts;
  final List<IncomeExpenseReasons> reasons;
  final List<PartnersModel> partners;
  final List<PartnerTypesModel> partnerTypes;

  const MenuCacheSnapshot({
    required this.transactions,
    required this.accounts,
    required this.reasons,
    required this.partners,
    required this.partnerTypes,
  });

  Map<String, dynamic> toMap() {
    return {
      'transactions': transactions.map((e) => e.toMap()).toList(),
      'accounts': accounts.map((e) => e.toMap()).toList(),
      'reasons': reasons.map((e) => e.toMap()).toList(),
      'partners': partners.map((e) => e.toMap()).toList(),
      'partnerTypes': partnerTypes.map((e) => e.toMap()).toList(),
    };
  }

  factory MenuCacheSnapshot.fromMap(Map<String, dynamic> map) {
    return MenuCacheSnapshot(
      transactions: ((map['transactions'] as List?) ?? [])
          .map((e) => AllTransactionsModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      accounts: ((map['accounts'] as List?) ?? [])
          .map((e) => AccountModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      reasons: ((map['reasons'] as List?) ?? [])
          .map(
            (e) => IncomeExpenseReasons.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList(),
      partners: ((map['partners'] as List?) ?? [])
          .map((e) => PartnersModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      partnerTypes: ((map['partnerTypes'] as List?) ?? [])
          .map((e) => PartnerTypesModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
