import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

final _log = Logger('THEME');

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('theme_mode') ?? 'system';
    _log.info('loaded theme_mode=$value');
    switch (value) {
      case 'light':
        emit(ThemeMode.light);
      case 'dark':
        emit(ThemeMode.dark);
      default:
        emit(ThemeMode.system);
    }
  }

  ThemeMode get next {
    if (state == ThemeMode.system) return ThemeMode.light;
    if (state == ThemeMode.light) return ThemeMode.dark;
    return ThemeMode.system;
  }

  IconData get icon {
    if (state == ThemeMode.light) return Icons.light_mode;
    if (state == ThemeMode.dark) return Icons.dark_mode;
    return Icons.brightness_auto;
  }

  Future<void> cycleTo(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String key;
    if (mode == ThemeMode.system) {
      key = 'system';
    } else if (mode == ThemeMode.light) {
      key = 'light';
    } else {
      key = 'dark';
    }
    await prefs.setString('theme_mode', key);
    _log.info('saved theme_mode=$key');
    emit(mode);
  }

  Future<void> cycle() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = next;
    String key;
    if (newMode == ThemeMode.system) {
      key = 'system';
    } else if (newMode == ThemeMode.light) {
      key = 'light';
    } else {
      key = 'dark';
    }
    await prefs.setString('theme_mode', key);
    _log.info('saved theme_mode=$key');
    emit(newMode);
  }
}
