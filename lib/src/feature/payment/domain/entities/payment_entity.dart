class PaymentEntity {
  PaymentEntity({
    required this.id,
    this.orderId,
    this.finikTransactionId,
    this.amount,
    this.status,
    this.createdAt,
    this.company,
    this.user,
    this.subscription,
    this.plan,
    this.period,
  });

  final int id;
  final String? orderId;
  final String? finikTransactionId;
  final String? amount;
  final String? status;
  final String? createdAt;
  final int? company;
  final int? user;
  final int? subscription;
  final int? plan;
  final int? period;
}
