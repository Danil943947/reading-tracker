class AuthSession {
  const AuthSession({required this.token, required this.email});
  final String token;
  final String email;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    token: json['token'] as String, email: json['email'] as String,
  );
  Map<String, dynamic> toJson() => {'token': token, 'email': email};
  AuthSession copyWith({String? token, String? email}) => AuthSession(
    token: token ?? this.token, email: email ?? this.email,
  );
}
