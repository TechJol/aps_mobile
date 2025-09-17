class AuthSession {
  const AuthSession({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.companyId,
  });

  final String? accessToken;
  final String? refreshToken;
  final int? userId;
  final int? companyId;
}
