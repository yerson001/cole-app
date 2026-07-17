// ────────────────────────────────────────────────────────────
// DOMAIN LAYER — Pura lógica de negocio (sin Flutter, sin API)
// ────────────────────────────────────────────────────────────
// Define el CONTRATO que la capa DATA debe implementar.
// domain/ NO conoce a data/ — la inyección de dependencias
// la hace presentation/ al construir el repo con su impl.
//
// Flujo: UseCase → AuthRepository (abstracto) → AuthRepositoryImpl
//                                                     ↓
//                                              AuthService (HTTP)
//
// Quién lo usa? → LoginUseCase (domain)
// Quién lo implementa? → AuthRepositoryImpl (data)
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  Future<Resource<AuthResponse>> login(
      String tenant, String username, String password);
  Future<void> saveUserSession(AuthResponse authResponse);
  Future<AuthResponse?> getUserSession();
  Future<void> removeUserSession();
  Future<bool> logout();
}
