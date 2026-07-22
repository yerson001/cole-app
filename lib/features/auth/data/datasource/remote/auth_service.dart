// ────────────────────────────────────────────────────────────
// DATA LAYER — Servicio HTTP (remoto)
// ────────────────────────────────────────────────────────────
// RESPONSABILIDAD ÚNICA: hablar con el backend por HTTP.
//
// Esta clase NO sabe nada de:
//   - SharedPreferences (eso es trabajo de AuthLocalStorage)
//   - BLoC ni eventos
//   - Use cases
//
// Solo sabe hacer UNA COSA: POST al backend y devolver AuthResponse.
//
// ¿Quién la usa?
//   - AuthRepositoryImpl (el repositorio la llama cuando necesita internet)
//
// ¿Por qué existe separada?
//   - Porque si mañana el backend cambia de URL o de formato,
//     solo toco este archivo y el resto de la app no se entera.
// ────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Hace POST a backend.colecheck.com/auth/login
  /// Devuelve AuthResponse con token, user, roles, etc.
  Future<AuthResponse> login({
    required String tenant,
    required String username,
    required String password,
  }) async {
    final t = tenant.trim();
    final u = username.trim();
    final uri = Uri.parse('${ApiConstants.baseUrl}/auth/login');

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': t,
      },
      body: jsonEncode({'username': u, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
        tenant: t,
      );
      return authResponse;
    }
    throw Exception(
      'Error en login: ${response.statusCode} ${response.body}',
    );
  }
}
