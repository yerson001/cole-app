import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

class AuthLocalDatasource {
  static const String _sessionKey = 'colecheck_session';
  static const String _tenantKey = 'colecheck_tenant';
  String? _cachedTenantKey;

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> saveSession(AuthResponse authResponse) async {
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, json.encode(authResponse.toJson()));
  }

  Future<AuthResponse?> getSession() async {
    final prefs = await _prefs;
    final data = prefs.getString(_sessionKey);
    if (data != null && data.isNotEmpty) {
      return AuthResponse.fromJson(json.decode(data));
    }
    return null;
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }

  Future<void> saveTenantKey(String tenantKey) async {
    _cachedTenantKey = tenantKey;
    final prefs = await _prefs;
    await prefs.setString(_tenantKey, tenantKey);
  }

  String? getTenantKey() {
    return _cachedTenantKey;
  }

  Future<void> loadTenantKey() async {
    final prefs = await _prefs;
    _cachedTenantKey = prefs.getString(_tenantKey);
  }

  Future<void> clearTenantKey() async {
    _cachedTenantKey = null;
    final prefs = await _prefs;
    await prefs.remove(_tenantKey);
  }
}
