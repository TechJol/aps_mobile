import 'package:aps_mobile/src/feature/feature.dart';
import 'package:dartz/dartz.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  IncomeRepositoryImpl({required this.remoteIncomeDataSource});

  final RemoteIncomeDataSource remoteIncomeDataSource;

  @override
  Future<Either> addIncome(IncomeAndComeoutEntity income) async {
    return await remoteIncomeDataSource.addIncome(income);
  }
}
