// ────────────────────────────────────────────────────────────
// DATA LAYER — Implementación del repositorio
// ────────────────────────────────────────────────────────────
// ¿Por qué esta clase necesita AuthService y AuthLocalStorage?
//
// Porque el repositorio tiene DOS tipos de trabajo:
//
//   Trabajo 1 — COSAS DE INTERNET (remoto):
//     - login()       → llama al backend
//     → lo hace AuthService (HTTP)
//
//   Trabajo 2 — COSAS DEL CELULAR (local):
//     - saveUserSession()  → guarda en disco
//     - getUserSession()   → lee del disco
//     - logout()           → borra del disco
//     → lo hace AuthLocalStorage (SharedPreferences)
//
// Si solo tuviera AuthService → podría loguear, pero no guardar la sesión.
// Si solo tuviera AuthLocalStorage → podría guardar datos, pero no loguear.
// NECESITA AMBOS para funcionar completo.
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // ── DEPENDENCIAS ──────────────────────────────────────────
  // _authService  → sabe hacer HTTP (llamar al backend)
  // _storage      → sabe guardar/leer en el celular (SharedPreferences)
  final AuthService _authService;
  final AuthLocalStorage _storage;

  AuthRepositoryImpl({
    required this._authService,
    required AuthLocalStorage storage,
  })  : _storage = storage;

  // ── MÉTODOS ───────────────────────────────────────────────

  /// login(): USA EL SERVICIO HTTP (necesita internet)
  /// El AuthService hace POST al backend y devuelve AuthResponse.
  @override
  Future<Resource<AuthResponse>> login(
    String tenant,
    String username,
    String password,
  ) async {
    try {
      final response = await _authService.login(
        tenant: tenant,
        username: username,
        password: password,
      );
      return SuccessResource(response);
    } catch (e) {
      return ErrorResource(e.toString());
    }
  }

  /// saveUserSession(): USA EL STORAGE LOCAL (guarda en el celular)
  /// Guarda tenant (siempre), user (siempre), credentials (solo si rememberMe).
  @override
  Future<void> saveUserSession(AuthResponse authResponse,
      {bool rememberMe = false}) async {
    await _storage.save('tenant', authResponse.tenant);
    await _storage.save('user', authResponse.toJson());
    if (rememberMe) {
      await _storage.save('credentials', {
        'username': authResponse.user.username,
        'password': '',
      });
    } else {
      await _storage.remove('credentials');
    }
  }

  /// getUserSession(): USA EL STORAGE LOCAL (lee del celular)
  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await _storage.read('user');
    if (data != null) {
      final savedTenant = await getSavedTenant();
      final authResponse = AuthResponse.fromJson(
        data as Map<String, dynamic>,
        tenant: savedTenant ?? '',
      );
      return authResponse;
    }
    return null;
  }

  @override
  Future<String?> getSavedTenant() async {
    final data = await _storage.read('tenant');
    if (data is String) return data;
    return null;
  }

  @override
  Future<Map<String, String?>?> getSavedCredentials() async {
    final data = await _storage.read('credentials');
    if (data is Map) {
      return {
        'username': data['username'] as String?,
        'password': data['password'] as String?,
      };
    }
    return null;
  }

  @override
  Future<void> removeUserSession() async {
    await _storage.remove('user');
  }

  @override
  Future<bool> logout() async {
    await _storage.remove('user');
    await _storage.remove('credentials');
    return true;
  }
}
