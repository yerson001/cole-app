// ────────────────────────────────────────────────────────────
// SHARED LAYER — Persistencia local de sesión
// ────────────────────────────────────────────────────────────
// Singleton que envuelve SharedPreferences.
// Guarda/recupera: tenant, username, password, token, roles, profile.
// No pertenece a ninguna feature — es transversal.
//
// Quién lo usa? → AuthRepositoryImpl (data)
// ────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static final SessionStorage _instance = SessionStorage._();
  static SessionStorage get instance => _instance;
  SessionStorage._();

  static const _tenantKey = 'tenant';
  static const _usernameKey = 'username';
  static const _passwordKey = 'password';
  static const _tokenKey = 'access_token';
  static const _rolesKey = 'roles';
  static const _profileKey = 'profile';

  Future<void> saveSession({
    required String tenant,
    required String username,
    required String password,
    required String token,
    required List<String> roles,
    required String profile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tenantKey, tenant);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_tokenKey, token);
    await prefs.setStringList(_rolesKey, roles);
    await prefs.setString(_profileKey, profile);
  }

  Future<String?> getTenant() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tenantKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<List<String>?> getRoles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_rolesKey);
  }

  Future<String?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tenantKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_rolesKey);
    await prefs.remove(_profileKey);
  }
}
