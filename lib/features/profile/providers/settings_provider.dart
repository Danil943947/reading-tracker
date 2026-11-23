import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this.repository);
  final SettingsRepository repository;
  AppSettings settings = const AppSettings();
  Object? error;

  ThemeMode get themeMode => settings.themeMode;
  String get defaultFilter => settings.defaultFilter;

  // Called before runApp to avoid flashing the wrong theme.
  Future<void> initialize() async { settings = await repository.load(); notifyListeners(); }

  Future<void> setTheme(ThemeMode mode) async {
    final previous = settings;
    settings = settings.copyWith(themeMode: mode);
    notifyListeners();
    try { await repository.save(settings); }
    catch (e) { error = e; settings = previous; notifyListeners(); }
  }

  Future<void> setDefaultFilter(String filter) async {
    final previous = settings;
    settings = settings.copyWith(defaultFilter: filter);
    notifyListeners();
    try { await repository.save(settings); }
    catch (e) { error = e; settings = previous; notifyListeners(); }
  }
}
