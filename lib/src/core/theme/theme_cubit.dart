import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({required this.sharedPreferences}) : super(ThemeMode.light);

  final SharedPreferences sharedPreferences;
  static const String _themeModeKey = 'app_theme_mode';

  Future<void> loadTheme() async {
    final value = sharedPreferences.getString(_themeModeKey);
    switch (value) {
      case 'dark':
        emit(ThemeMode.dark);
        return;
      case 'system':
        emit(ThemeMode.system);
        return;
      default:
        emit(ThemeMode.light);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    };
    await sharedPreferences.setString(_themeModeKey, value);
  }

  Future<void> toggleDark(bool enabled) async {
    await setThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
