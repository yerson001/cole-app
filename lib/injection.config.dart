// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:coleapp/di/app_module.dart' as _i425;
import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart'
    as _i800;
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart'
    as _i1057;
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart'
    as _i509;
import 'package:coleapp/features/auth/domain/usecases/auth_use_cases.dart'
    as _i543;
import 'package:coleapp/features/auth/domain/usecases/getUserSession_use_case.dart'
    as _i634;
import 'package:coleapp/features/auth/domain/usecases/login_use_case.dart'
    as _i905;
import 'package:coleapp/features/auth/domain/usecases/logout_use_case.dart'
    as _i690;
import 'package:coleapp/features/auth/domain/usecases/removeUser_use_case.dart'
    as _i507;
import 'package:coleapp/features/auth/domain/usecases/saveUser_use_case.dart'
    as _i1056;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i800.AuthLocalStorage>(() => appModule.authLocalStorage);
    gh.factory<_i1057.AuthService>(() => appModule.authService);
    gh.factory<_i509.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i905.LoginUseCase>(() => appModule.loginUseCase);
    gh.factory<_i1056.SaveuserUseCase>(() => appModule.saveuserUseCase);
    gh.factory<_i634.GetusersessionUseCase>(
      () => appModule.getusersessionUseCase,
    );
    gh.factory<_i507.RemoveuserUseCase>(() => appModule.removeuserUseCase);
    gh.factory<_i690.LogoutUseCase>(() => appModule.logoutUseCase);
    gh.factory<_i543.AuthUseCases>(() => appModule.authUseCases);
    return this;
  }
}

class _$AppModule extends _i425.AppModule {}
