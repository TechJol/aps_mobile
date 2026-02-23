import 'package:aps_mobile/src/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeCubit', () {
    test('loadTheme emits dark when stored value is dark', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(sharedPreferences: prefs);

      await cubit.loadTheme();

      expect(cubit.state, ThemeMode.dark);
      await cubit.close();
    });

    test('loadTheme emits light by default', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(sharedPreferences: prefs);

      await cubit.loadTheme();

      expect(cubit.state, ThemeMode.light);
      await cubit.close();
    });

    test('toggleDark(true/false) updates state and persisted value', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = ThemeCubit(sharedPreferences: prefs);

      await cubit.toggleDark(true);
      expect(cubit.state, ThemeMode.dark);
      expect(prefs.getString('app_theme_mode'), 'dark');

      await cubit.toggleDark(false);
      expect(cubit.state, ThemeMode.light);
      expect(prefs.getString('app_theme_mode'), 'light');

      await cubit.close();
    });
  });
}
