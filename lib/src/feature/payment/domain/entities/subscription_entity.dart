// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubscriptionEntity {
  SubscriptionEntity({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.company,
    required this.user,
    required this.plan,
    required this.period,
  });

  final int id;
  final String startDate;
  final String endDate;
  final bool isActive;
  final int company;
  final int user;
  final int? plan;
  final int? period;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
      'company': company,
      'user': user,
      'plan': plan,
      'period': period,
    };
  }

  factory SubscriptionEntity.fromMap(Map<String, dynamic> map) {
    return SubscriptionEntity(
      id: map['id'] as int,
      startDate: map['start_date'] as String? ?? '',
      endDate: map['end_date'] as String? ?? '',
      isActive: _parseBool(map['is_active']),
      company: map['company'] as int? ?? 0,
      user: map['user'] as int? ?? 0,
      plan: map['plan'] as int?,
      period: map['period'] as int?,
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

  factory SubscriptionEntity.fromJson(String source) =>
      SubscriptionEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
