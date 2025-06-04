import 'package:aps_mobile/src/feature/auth/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.username,
    required super.password,
    super.email,
    super.firstName,
    super.lastName,
    super.companyName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    username: json['username'],
    password: json['password'],
    email: json['email'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    companyName: json['company_name'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'company_name': companyName,
  };
}
