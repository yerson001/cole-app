import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  bool _tenantKeyLoaded = false;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Resource<AuthResponse>> login(
      String dni, String password, String tenantKey) {
    return remote.login(dni, password, tenantKey);
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    await local.saveSession(authResponse);
    if (authResponse.tenantKey != null) {
      await local.saveTenantKey(authResponse.tenantKey!);
    }
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    return local.getSession();
  }

  @override
  Future<void> removeUserSession() async {
    await local.clearSession();
  }

  @override
  Future<bool> logout() async {
    await local.clearSession();
    return true;
  }

  @override
  Future<void> saveTenantKey(String tenantKey) async {
    await local.saveTenantKey(tenantKey);
  }

  @override
  String? getTenantKey() {
    if (!_tenantKeyLoaded) {
      _tenantKeyLoaded = true;
      local.loadTenantKey();
    }
    return local.getTenantKey();
  }
}
