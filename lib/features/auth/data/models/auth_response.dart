import 'package:coleapp/features/auth/data/models/user.dart';
import 'package:coleapp/features/auth/data/models/profile.dart';

class AuthResponse {
  final User user;
  final String token;
  final List<String>? roles;
  final Profile? profile;
  final String? tenant;

  AuthResponse({
    required this.user,
    required this.token,
    this.roles,
    this.profile,
    this.tenant,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: User.fromJson(json["user"] ?? json),
    token: json["access_token"] ?? json["token"] ?? '',
    roles: json["roles"] != null
        ? List<String>.from(json["roles"].map((x) => x is String ? x : x["name"] ?? ''))
        : null,
    profile: json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
    tenant: json["tenant"] as String?,
  );
}
