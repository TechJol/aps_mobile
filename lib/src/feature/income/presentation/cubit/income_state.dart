import 'package:aps_mobile/src/feature/feature.dart';
import 'package:equatable/equatable.dart';

class IncomeState extends Equatable {
  final List<AccountModel> accounts;
  final List<IncomeExpenseReasons> reasons;
  final List<PartnerTypesModel> partnerTypes;
  final List<PartnersModel> partners;
  final bool isLoading;
  final bool incomeSaved;
  final String? error;

  const IncomeState({
    this.accounts = const [],
    this.reasons = const [],
    this.partnerTypes = const [],
    this.partners = const [],
    this.isLoading = false,
    this.incomeSaved = false,
    this.error,
  });

  IncomeState copyWith({
    List<AccountModel>? accounts,
    List<IncomeExpenseReasons>? reasons,
    List<PartnerTypesModel>? partnerTypes,
    List<PartnersModel>? partners,
    bool? isLoading,
    bool? incomeSaved,
    String? error,
  }) {
    return IncomeState(
      accounts: accounts ?? this.accounts,
      reasons: reasons ?? this.reasons,
      partnerTypes: partnerTypes ?? this.partnerTypes,
      partners: partners ?? this.partners,
      isLoading: isLoading ?? this.isLoading,
      incomeSaved: incomeSaved ?? this.incomeSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    accounts,
    reasons,
    partnerTypes,
    partners,
    isLoading,
    incomeSaved,
    error,
  ];
}
