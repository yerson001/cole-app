import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:coleapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:coleapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/get_session_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/save_session_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:coleapp/features/auth/domain/usecases/get_tenant_key_usecase.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @Injectable()
  Dio get dio {
    final d = Dio(BaseOptions(
      baseUrl: 'http://${ApiConstants.baseUrl}',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: ApiConstants.headers,
    ));
    d.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    return d;
  }

  @Injectable()
  AuthLocalDatasource get authLocalDatasource =>
      AuthLocalDatasource();

  @Injectable()
  AuthRemoteDatasource get authRemoteDatasource =>
      AuthRemoteDatasource(dio: dio);

  @Injectable()
  AuthRepository get authRepository =>
      AuthRepositoryImpl(
        remote: authRemoteDatasource,
        local: authLocalDatasource,
      );

  @Injectable()
      AuthUseCases get authUseCases => AuthUseCases(
        login: LoginUseCase(authRepository),
        getSession: GetSessionUseCase(authRepository),
        save: SaveSessionUseCase(authRepository),
        logout: LogoutUseCase(authRepository),
        getTenantKey: GetTenantKeyUseCase(authRepository),
      );
}
