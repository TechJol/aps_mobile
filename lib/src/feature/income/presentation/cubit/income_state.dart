import 'package:aps_mobile/src/feature/feature.dart';
import 'package:equatable/equatable.dart';

class IncomeState extends Equatable {
  final List<AccountModel> accounts;
  final List<IncomeExpenseReasons> reasons;
  final bool isLoading;
  final bool incomeSaved;
  final String? error;

  const IncomeState({
    this.accounts = const [],
    this.reasons = const [],
    this.isLoading = false,
    this.incomeSaved = false,
    this.error,
  });

  IncomeState copyWith({
    List<AccountModel>? accounts,
    List<IncomeExpenseReasons>? reasons,
    bool? isLoading,
    bool? incomeSaved,
    String? error,
  }) {
    return IncomeState(
      accounts: accounts ?? this.accounts,
      reasons: reasons ?? this.reasons,
      isLoading: isLoading ?? this.isLoading,
      incomeSaved: incomeSaved ?? this.incomeSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props => [accounts, reasons, isLoading, incomeSaved, error];
}
