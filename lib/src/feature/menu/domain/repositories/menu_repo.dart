import 'package:dartz/dartz.dart';

abstract class MenuRepository {
  Future<Either> getTransactions();

  Future<Either> getPartners();

  Future<Either> deletePartner(int id);
}
