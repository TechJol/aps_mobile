import 'package:aps_mobile/src/feature/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    super.id,
    required super.username,
    required super.password,
    super.email,
    super.firstName,
    super.lastName,
    super.companyName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    id: json['id'],
    username: json['username'],
    password: json['password'] ?? '',
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    companyName: json['company_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'password': password,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'company_name': companyName,
  };

  factory AuthModel.fromEntity(AuthEntity entity) => AuthModel(
    id: entity.id,
    username: entity.username,
    password: entity.password,
    email: entity.email,
    firstName: entity.firstName,
    lastName: entity.lastName,
    companyName: entity.companyName,
  );
}
