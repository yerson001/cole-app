import 'package:coleapp/features/auth/data/models/user.dart';

class AuthResponse {
  final User user;
  final String token;
  String? tenantKey;

  AuthResponse({
    required this.user,
    required this.token,
    this.tenantKey,
  });

  AuthResponse copyWith({String? tenantKey}) =>
      AuthResponse(user: user, token: token, tenantKey: tenantKey ?? this.tenantKey);

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        user: User.fromJson(json["user"] ?? json),
        token: json["access_token"] ?? json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
        "tenantKey": tenantKey,
      };
}
