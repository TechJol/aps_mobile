import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:dartz/dartz.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({required this.remoteDataSource});

  final PaymentRemoteDataSource remoteDataSource;

  @override
  Future<Either> getPlans() async {
    return await remoteDataSource.getPlans();
  }

  @override
  Future<Either> getPeriods() async {
    return await remoteDataSource.getPeriods();
  }

  @override
  Future<Either> startPayment({required int planId, required int periodId}) {
    return remoteDataSource.startPayment(planId: planId, periodId: periodId);
  }

  @override
  Future<Either> getSubscriptions() async {
    return await remoteDataSource.getSubscriptions();
  }
}
