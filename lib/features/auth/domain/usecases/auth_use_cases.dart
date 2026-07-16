import 'package:coleapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/get_session_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/save_session_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/get_tenant_key_usecase.dart';

class AuthUseCases {
  final LoginUseCase login;
  final GetSessionUseCase getSession;
  final SaveSessionUseCase save;
  final LogoutUseCase logout;
  final GetTenantKeyUseCase getTenantKey;

  AuthUseCases({
    required this.login,
    required this.getSession,
    required this.save,
    required this.logout,
    required this.getTenantKey,
  });
}
