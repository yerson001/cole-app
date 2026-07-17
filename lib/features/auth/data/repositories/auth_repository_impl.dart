// ────────────────────────────────────────────────────────────
// DATA LAYER — Implementación concreta de los contratos
// ────────────────────────────────────────────────────────────
// AuthRepositoryImpl implementa el contrato definido en domain/.
// Orquesta AuthService (HTTP) + SessionStorage (SharedPrefs).
// Convierte Respuesta HTTP → Resource<AuthResponse>.
//
// domain/ → AuthRepository (interfaz)
//            ↑ implementa
// data/   → AuthRepositoryImpl
//            ↓ usa
//            AuthService (HTTP) + SessionStorage (local)
//
// Quién lo usa? → LoginUseCase (domain) via AuthRepository
// Quién lo llama? → El repo es inyectado por DI (GetIt)
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:coleapp/shared/utils/session_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final SessionStorage _sessionStorage;

  AuthRepositoryImpl({
    required AuthService authService,
    required SessionStorage sessionStorage,
  })  : _authService = authService,
        _sessionStorage = sessionStorage;

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

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    final roles = authResponse.roles ?? [];
    final profileType = authResponse.profile?.type ?? '';
    final tenant = authResponse.tenant ?? '';

    await _sessionStorage.saveSession(
      tenant: tenant,
      username: '',
      password: '',
      token: authResponse.token,
      roles: roles,
      profile: profileType,
    );
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    return null;
  }

  @override
  Future<void> removeUserSession() async {
    await _sessionStorage.clear();
  }

  @override
  Future<bool> logout() async {
    await _sessionStorage.clear();
    return true;
  }
}
