// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlanEntity {
  PlanEntity({
    required this.id,
    required this.name,
    required this.pricePerMonth,
    required this.isActive,
  });

  final int id;
  final String name;
  final double pricePerMonth;
  final bool isActive;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price_per_month': pricePerMonth,
      'is_active': isActive,
    };
  }

  factory PlanEntity.fromMap(Map<String, dynamic> map) {
    final priceRaw = map['price_per_month'];
    final price = priceRaw is num
        ? priceRaw.toDouble()
        : double.tryParse(priceRaw?.toString() ?? '') ?? 0;

    return PlanEntity(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      pricePerMonth: price,
      isActive: _parseBool(map['is_active']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    return false;
  }

  String toJson() => json.encode(toMap());

  factory PlanEntity.fromJson(String source) =>
      PlanEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
