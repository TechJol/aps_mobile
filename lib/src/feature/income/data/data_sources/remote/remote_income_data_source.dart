import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class RemoteIncomeDataSource {
  Future<Either> addIncomeExpense(IncomeAndComeoutModel income);

  Future<Either> getAccount();

  Future<Either> getIncomeExpenseReasons();
}
