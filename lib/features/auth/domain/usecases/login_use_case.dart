// ────────────────────────────────────────────────────────────
// DOMAIN LAYER — Use case: LOGIN
// ────────────────────────────────────────────────────────────
// Un Use Case representa UNA SOLA ACCIÓN del negocio.
//
// LoginUseCase solo hace UNA COSA: loguear.
// No sabe de HTTP, no sabe de SharedPreferences.
// Solo llama al repositorio y le dice "logueá a este usuario".
//
// El repositorio (AuthRepositoryImpl) es el que sabe
// cómo loguear (usa AuthService para HTTP).
//
// ¿Quién usa esto?
//   - El BLoC (LoginBloc) cuando recibe el evento LoginSubmit
// ────────────────────────────────────────────────────────────

import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<Resource<AuthResponse>> call(
    String tenant,
    String username,
    String password,
  ) async {
    return await authRepository.login(tenant, username, password);
  }
}
