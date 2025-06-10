import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

abstract class RemoteIncomeDataSource {
  Future<Either> addIncome(IncomeAndComeoutModel income);
}
