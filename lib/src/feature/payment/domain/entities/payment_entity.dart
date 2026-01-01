// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orderId': orderId,
      'finikTransactionId': finikTransactionId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt,
      'company': company,
      'user': user,
      'subscription': subscription,
      'plan': plan,
      'period': period,
    };
  }

  factory PaymentEntity.fromMap(Map<String, dynamic> map) {
    return PaymentEntity(
      id: map['id'] as int,
      orderId: map['orderId'] != null ? map['orderId'] as String : null,
      finikTransactionId: map['finikTransactionId'] != null
          ? map['finikTransactionId'] as String
          : null,
      amount: map['amount'] != null ? map['amount'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      company: map['company'] != null ? map['company'] as int : null,
      user: map['user'] != null ? map['user'] as int : null,
      subscription: map['subscription'] != null
          ? map['subscription'] as int
          : null,
      plan: map['plan'] != null ? map['plan'] as int : null,
      period: map['period'] != null ? map['period'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentEntity.fromJson(String source) =>
      PaymentEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
