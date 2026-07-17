// ────────────────────────────────────────────────────────────
// DATA LAYER — Servicio HTTP para autenticación
// ────────────────────────────────────────────────────────────
// Capa más externa: comunicación con la API.
// Usa package:http (NO Dio).
// Envía POST /auth/login con tenant-id en header.
// Recibe JSON → lo convierte a AuthResponse vía fromJson.
//
// domain/ no conoce esta clase — solo AuthRepositoryImpl la usa.
//
// Quién lo usa? → AuthRepositoryImpl (data)
// Qué depende de él? → NADA (es hoja del árbol de dependencias)
// ────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coleapp/core/constants/api_constants.dart';
import 'package:coleapp/features/auth/data/models/auth_response.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> login({
    required String tenant,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/auth/login');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'tenant-id': tenant,
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception(
      'Error en login: ${response.statusCode} ${response.body}',
    );
  }
}
