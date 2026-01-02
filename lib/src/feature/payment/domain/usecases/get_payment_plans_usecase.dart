import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:dartz/dartz.dart';

class GetPaymentPlansUsecase {
  GetPaymentPlansUsecase({required this.repository});

  final PaymentRepository repository;

  Future<Either> call() async => await repository.getPlans();
}
