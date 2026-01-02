// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PeriodEntity {
  PeriodEntity({
    required this.id,
    required this.name,
    required this.months,
    required this.discountPercent,
  });

  final int id;
  final String name;
  final int months;
  final int discountPercent;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'months': months,
      'discount_percent': discountPercent,
    };
  }

  factory PeriodEntity.fromMap(Map<String, dynamic> map) {
    return PeriodEntity(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      months: map['months'] as int? ?? 0,
      discountPercent: map['discount_percent'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PeriodEntity.fromJson(String source) =>
      PeriodEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
