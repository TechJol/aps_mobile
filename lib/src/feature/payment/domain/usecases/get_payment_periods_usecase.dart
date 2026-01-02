import 'package:aps_mobile/src/feature/payment/payment.dart';
import 'package:dartz/dartz.dart';

class GetPaymentPeriodsUsecase {
  GetPaymentPeriodsUsecase({required this.repository});

  final PaymentRepository repository;

  Future<Either> call() async => await repository.getPeriods();
}
