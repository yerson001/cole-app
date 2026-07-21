// ────────────────────────────────────────────────────────────
// MOCHILA que agrupa TODOS los use cases del módulo Auth
// ────────────────────────────────────────────────────────────
// ¿Por qué existe esta clase?
//
// Porque el BLoC (LoginBloc) necesita VARIOS use cases:
//   - loginUseCase       → para loguear
//   - saveuserUseCase    → para guardar sesión
//   - getusersession...  → para recuperar sesión
//   - removeuserUseCase  → para borrar sesión
//   - logoutUseCase      → para cerrar sesión
//
// En vez de pasarle 5 parámetros al BLoC:
//   LoginBloc(loginUseCase, saveuserUseCase, ..., logoutUseCase);
//
// Le pasamos UNO SOLO:
//   LoginBloc(this.authUseCases);
//   Y adentro: authUseCases.loginUseCase.call()
//              authUseCases.saveuserUseCase.call()
//
// Más limpio, más fácil de mantener.
// ────────────────────────────────────────────────────────────

import 'package:coleapp/features/auth/domain/usecases/getUserSession_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/removeUser_use_case.dart';
import 'package:coleapp/features/auth/domain/usecases/saveUser_use_case.dart';

class AuthUseCases {
  final LoginUseCase loginUseCase;
  final SaveuserUseCase saveuserUseCase;
  final GetusersessionUseCase getusersessionUseCase;
  final RemoveuserUseCase removeuserUseCase;
  final LogoutUseCase logoutUseCase;

  AuthUseCases({
    required this.loginUseCase,
    required this.saveuserUseCase,
    required this.getusersessionUseCase,
    required this.removeuserUseCase,
    required this.logoutUseCase,
  });
}
