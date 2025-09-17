import 'package:aps_mobile/src/feature/auth/domain/entities/auth_session.dart';

class LoginResponseModel {
  final String? access;
  final String? refresh;
  final int? companyId;
  final int? userId;

  const LoginResponseModel({
    this.access,
    this.refresh,
    this.companyId,
    this.userId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access: json['access'] as String?,
      refresh: json['refresh'] as String?,
      companyId: json['company_id'] is int ? json['company_id'] as int? : null,
      userId: json['user_id'] is int ? json['user_id'] as int? : null,
    );
  }

  AuthSession toSession() => AuthSession(
        accessToken: access,
        refreshToken: refresh,
        companyId: companyId,
        userId: userId,
      );
}
