// depedenci injection
/*
AuthService get authService {
  return AuthService();
}
*/

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

@module
abstract class AppModule {
  @injectable
  AuthLocalStorage get authLocalStorage => AuthLocalStorage();

  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository => AuthRepositoryImpl(
    authService: authService,
    storage: authLocalStorage,
  );

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

  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
    loginUseCase: loginUseCase,
    saveuserUseCase: saveuserUseCase,
    getusersessionUseCase: getusersessionUseCase,
    removeuserUseCase: removeuserUseCase,
    logoutUseCase: logoutUseCase,
  );
}
