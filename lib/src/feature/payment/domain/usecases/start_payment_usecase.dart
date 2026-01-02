import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:dartz/dartz.dart';

class StartPaymentUsecase {
  StartPaymentUsecase({required this.repository});

  final PaymentRepository repository;

  Future<Either> call({required int planId, required int periodId}) async {
    return await repository.startPayment(planId: planId, periodId: periodId);
  }
}
