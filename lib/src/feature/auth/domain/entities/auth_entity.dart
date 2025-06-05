class AuthEntity {
  const AuthEntity({
    required this.username,
    required this.password,
    this.email,
    this.firstName,
    this.lastName,
    this.companyName,
  });

  final String username;
  final String password;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? companyName;
}
