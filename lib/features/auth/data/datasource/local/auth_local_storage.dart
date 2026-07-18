import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = Logger('STORAGE');

class AuthLocalStorage {
  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
    _log.info('save("$key") -> OK');
  }

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

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.remove(key);
    _log.info('remove("$key") -> $result');
    return result;
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.containsKey(key);
    _log.info('contains("$key") -> $result');
    return result;
  }
}
