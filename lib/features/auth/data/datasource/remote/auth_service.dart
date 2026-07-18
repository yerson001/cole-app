import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

final _log = Logger('API');

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> login({
    required String tenant,
    required String username,
    required String password,
  }) async {
    final t = tenant.trim();
    final u = username.trim();
    final uri = Uri.parse('${ApiConstants.baseUrl}/auth/login');
    _log.info('POST $uri');
    _log.info('tenant-id: $t');
    _log.info('Body: username=$u password=$password');

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': t,
      },
      body: jsonEncode({'username': u, 'password': password}),
    );

    _log.info('Status=${response.statusCode}');
    _log.info('Body=${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
        tenant: t,
      );
      _log.info('Login OK');
      _log.info('  token=${authResponse.token}');
      _log.info('  user.id=${authResponse.user.id} user.username=${authResponse.user.username}');
      _log.info('  roles=${authResponse.user.roles}');
      _log.info('  profile=${authResponse.user.profile?.type}');
      return authResponse;
    }
    _log.severe('Error HTTP ${response.statusCode}');
    throw Exception(
      'Error en login: ${response.statusCode} ${response.body}',
    );
  }
}
