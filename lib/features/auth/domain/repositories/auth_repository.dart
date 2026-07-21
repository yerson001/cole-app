// ────────────────────────────────────────────────────────────
// DOMAIN LAYER — Pura lógica de negocio (sin Flutter, sin API)
// ────────────────────────────────────────────────────────────
// Esto es un CONTRATO (interfaz).
// Define QUÉ se puede hacer, pero no CÓMO se hace.
//
// El "cómo" lo implementa AuthRepositoryImpl (en data/).
//
// ¿Por qué existe esta separación?
//   - DOMAIN: define el contrato (login, guardar sesión, etc.)
//   - DATA: implementa el contrato (usa HTTP, usa SharedPreferences)
//
// BENEFICIO: Si mañana cambiás de SharedPreferences a SQLite,
//            solo tocás AuthRepositoryImpl — DOMAIN no se entera.
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  /// Loguea al usuario contra el backend (USA INTERNET → AuthService)
  Future<Resource<AuthResponse>> login(
      String tenant, String username, String password);

  /// Guarda la sesión en el celular (USA DISCO → AuthLocalStorage)
  Future<void> saveUserSession(AuthResponse authResponse,
      {bool rememberMe = false});

  /// Recupera la sesión guardada (USA DISCO → AuthLocalStorage)
  Future<AuthResponse?> getUserSession();

  /// Recupera solo el tenant guardado (USA DISCO → AuthLocalStorage)
  Future<String?> getSavedTenant();

  /// Recupera credenciales guardadas si existían (USA DISCO → AuthLocalStorage)
  Future<Map<String, String?>?> getSavedCredentials();

  /// Borra la sesión (USA DISCO → AuthLocalStorage)
  Future<void> removeUserSession();

  /// Cierra sesión: borra user + credentials (USA DISCO → AuthLocalStorage)
  Future<bool> logout();
}
