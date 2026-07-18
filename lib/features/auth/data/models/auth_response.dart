import 'package:coleapp/features/auth/data/models/user.dart';

class AuthResponse {
  final User user;
  final String token;
  final String tenant;

  AuthResponse({
    required this.user,
    required this.token,
    required this.tenant,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json, {String tenant = ''}) => AuthResponse(
    user: User.fromJson(json["user"] ?? json),
    token: json["access_token"] ?? json["token"] ?? '',
    tenant: tenant,
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'access_token': token,
    'tenant': tenant,
  };
}
