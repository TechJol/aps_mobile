import 'package:dartz/dartz.dart';

abstract class PaymentRepository {
  Future<Either> getPlans();

  Future<Either> getPeriods();

  Future<Either> startPayment({required int planId, required int periodId});
}
