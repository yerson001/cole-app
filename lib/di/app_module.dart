// ────────────────────────────────────────────────────────────
// MÓDULO DE INYECCIÓN DE DEPENDENCIAS (DI)
// ────────────────────────────────────────────────────────────
// Este archivo es como un CATÁLOGO que le dice a GetIt:
//   "Si alguien pide X, créalo así."
//
// CADENA DE DEPENDENCIAS (de abajo hacia arriba):
//
//   AuthLocalStorage  ← no necesita nada (es hoja)
//   AuthService       ← no necesita nada (es hoja)
//        ↓
//   AuthRepositoryImpl ← necesita: AuthService + AuthLocalStorage
//        ↓
//   LoginUseCase      ← necesita: AuthRepository
//   SaveuserUseCase   ← necesita: AuthRepository
//   Getusersession... ← necesita: AuthRepository
//   LogoutUseCase     ← necesita: AuthRepository
//   RemoveuserUseCase ← necesita: AuthRepository
//        ↓
//   AuthUseCases      ← necesita: todos los use cases arriba
//        ↓
//   LoginBloc         ← necesita: AuthUseCases
//
// ¿Por qué tanta cadena?
//   - Cada clase tiene UNA SOLA RESPONSABILIDAD
//   - AuthService SOLO sabe hacer HTTP
//   - AuthLocalStorage SOLO sabe leer/escribir en disco
//   - AuthRepositoryImpl USA ambos para hacer login COMPLETO
//     (login por internet + guardar sesión en disco)
//   - Los Use Cases son "mozos" que hacen UN SOLO mandado
//   - AuthUseCases es la "mochila" que los agrupa
// ────────────────────────────────────────────────────────────

import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart';
import 'package:coleapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/domain/usecases/getUserSession_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/removeUser_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/saveUser_use_case.dart';
import 'package:injectable/injectable.dart';

/*
AuthRepository authRepository() {
  return AuthRepositoryImpl(...);
  // Esto:
int get suma => a + b;

// Es lo mismo que:
int get suma {
  return a + b;
}
}*/

@module
abstract class AppModule {
  // ── HOJAS (no necesitan nada) ─────────────────────────────

  @injectable
  AuthLocalStorage get authLocalStorage => AuthLocalStorage();

  @injectable
  AuthService get authService => AuthService();

  // ── REPOSITORIO (necesita service + storage) ──────────────
  // ¿Por qué necesita ambos?
  //   - AuthService → para login() [internet]
  //   - AuthLocalStorage → para saveUserSession()/getUserSession() [disco]


  // implementacion esta en auth_repository_impl.dart
  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(
    authService: authService,
    storage: authLocalStorage,
  );

  // ── USE CASES (cada uno necesita el repositorio) ──────────
  // Cada use case es una ACCIÓN específica.
  // LoginUseCase solo sabe loguear.
  // SaveuserUseCase solo sabe guardar sesión.
  // Y así...

  @injectable
  LoginUseCase get loginUseCase => LoginUseCase(authRepository: authRepository);

  @injectable
  SaveuserUseCase get saveuserUseCase => SaveuserUseCase(authRepository);

  @injectable
  GetusersessionUseCase get getusersessionUseCase =>
      GetusersessionUseCase(authRepository);

  @injectable
  RemoveuserUseCase get removeuserUseCase => RemoveuserUseCase(authRepository);

  @injectable
  LogoutUseCase get logoutUseCase => LogoutUseCase(authRepository);

  // ── MOCHILA DE USE CASES ──────────────────────────────────
  // Agrupa todos los use cases en UN SOLO objeto
  // para que el BLoC reciba un solo parámetro en lugar de 5.

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    loginUseCase: loginUseCase,
    saveuserUseCase: saveuserUseCase,
    getusersessionUseCase: getusersessionUseCase,
    removeuserUseCase: removeuserUseCase,
    logoutUseCase: logoutUseCase,
  );
}
