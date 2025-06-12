import 'package:dartz/dartz.dart';

abstract class RemoteMenuDataSource {
  Future<Either> getTransactions();

  Future<Either> getPartners();
}
