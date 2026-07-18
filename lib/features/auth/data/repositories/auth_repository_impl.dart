import 'package:logging/logging.dart';
import 'package:coleapp/core/errors/resource.dart';
import 'package:coleapp/features/auth/data/datasource/local/auth_local_storage.dart';
import 'package:coleapp/features/auth/data/datasource/remote/auth_service.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';
import 'package:coleapp/features/auth/domain/repositories/auth_repository.dart';

final _log = Logger('REPO');

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AuthLocalStorage _storage;

  AuthRepositoryImpl({
    required AuthService authService,
    required AuthLocalStorage storage,
  })  : _authService = authService,
        _storage = storage;

  @override
  Future<Resource<AuthResponse>> login(
    String tenant,
    String username,
    String password,
  ) async {
    _log.info('login() tenant=$tenant username=$username password=$password');
    try {
      final response = await _authService.login(
        tenant: tenant,
        username: username,
        password: password,
      );
      _log.info('login OK');
      return SuccessResource(response);
    } catch (e) {
      _log.severe('login falló: $e');
      return ErrorResource(e.toString());
    }
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse,
      {bool rememberMe = false}) async {
    _log.info('Guardando sesión (rememberMe=$rememberMe)');
    await _storage.save('tenant', authResponse.tenant);
    await _storage.save('user', authResponse.toJson());
    if (rememberMe) {
      await _storage.save('credentials', {
        'username': authResponse.user.username,
        'password': '',
      });
    } else {
      await _storage.remove('credentials');
    }
    _log.info('Sesión guardada');
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    _log.info('getUserSession()');
    final data = await _storage.read('user');
    if (data != null) {
      final authResponse = AuthResponse.fromJson(data as Map<String, dynamic>);
      _log.info('Sesión recuperada');
      return authResponse;
    }
    _log.info('No hay sesión guardada');
    return null;
  }

  @override
  Future<String?> getSavedTenant() async {
    final data = await _storage.read('tenant');
    if (data is String) return data;
    return null;
  }

  @override
  Future<Map<String, String?>?> getSavedCredentials() async {
    final data = await _storage.read('credentials');
    if (data is Map) {
      return {
        'username': data['username'] as String?,
        'password': data['password'] as String?,
      };
    }
    return null;
  }

  @override
  Future<void> removeUserSession() async {
    _log.info('removeUserSession()');
    await _storage.remove('user');
  }

  @override
  Future<bool> logout() async {
    _log.info('logout()');
    await _storage.remove('user');
    await _storage.remove('credentials');
    return true;
  }
}
