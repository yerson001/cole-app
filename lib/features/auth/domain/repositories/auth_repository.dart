import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  Future<Resource<AuthResponse>> login(
      String dni, String password, String tenantKey);
  Future<void> saveUserSession(AuthResponse authResponse);
  Future<AuthResponse?> getUserSession();
  Future<void> removeUserSession();
  Future<bool> logout();
  Future<void> saveTenantKey(String tenantKey);
  String? getTenantKey();
}
