// ────────────────────────────────────────────────────────────
// DATA LAYER — Almacenamiento local (disco del celular)
// ────────────────────────────────────────────────────────────
// RESPONSABILIDAD ÚNICA: guardar/leer/borrar datos en el celular.
//
// Esta clase NO sabe nada de:
//   - HTTP ni backend (eso es trabajo de AuthService)
//   - BLoC ni eventos
//   - Use cases
//
// Solo sabe hacer UNA COSA: guardar y leer datos con SharedPreferences.
// Es genérica: save("cualquierKey", cualquierValor).
//
// ¿Quién la usa?
//   - AuthRepositoryImpl (el repositorio la llama cuando necesita disco)
//
// ¿Por qué existe separada?
//   - Porque si mañana cambiás SharedPreferences por SQLite o archivos,
//     solo toco este archivo y el resto de la app no se entera.
// ────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = Logger('STORAGE');

class AuthLocalStorage {
  /// Guarda cualquier valor (String, Map, List) bajo una key.
  /// Internamente convierte a JSON y lo guarda como String.
  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
    _log.info('save("$key") -> OK');
  }

  /// Lee el valor guardado bajo una key.
  /// Devuelve el objeto decodeado (Map, String, etc.) o null si no existe.
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(key);
    if (val != null) {
      _log.info('read("$key") -> datos encontrados');
      return json.decode(val);
    }
    _log.info('read("$key") -> null');
    return null;
  }

  /// Borra el valor bajo una key.
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.remove(key);
    _log.info('remove("$key") -> $result');
    return result;
  }

  /// Verifica si existe una key.
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.containsKey(key);
    _log.info('contains("$key") -> $result');
    return result;
  }
}
