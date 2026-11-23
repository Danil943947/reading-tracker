import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_tracker/features/profile/providers/settings_provider.dart';
import 'package:reading_tracker/features/profile/repositories/preferences_settings_repository.dart';

void main() {
  test('theme and default filter persist', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = PreferencesSettingsRepository(prefs);
    final settings = SettingsProvider(repo);
    await settings.initialize();
    await settings.setTheme(ThemeMode.dark);
    await settings.setDefaultFilter('completed');
    final reopened = SettingsProvider(repo);
    await reopened.initialize();
    expect(reopened.themeMode, ThemeMode.dark);
    expect(reopened.defaultFilter, 'completed');
    settings.dispose();
    reopened.dispose();
  });
}
