import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import 'settings_repository.dart';

class PreferencesSettingsRepository implements SettingsRepository {
  PreferencesSettingsRepository(this._preferences);
  final SharedPreferences _preferences;
  static const _key = 'reading_tracker_settings_v1';

  @override
  Future<AppSettings> load() async {
    final text = _preferences.getString(_key);
    if (text == null) return const AppSettings();
    try {
      return AppSettings.fromJson(jsonDecode(text) as Map<String, dynamic>);
    } on FormatException {
      return const AppSettings();
    } on TypeError {
      return const AppSettings();
    }
  }

  @override
  Future<void> save(AppSettings settings) async {
    final ok = await _preferences.setString(_key, jsonEncode(settings.toJson()));
    if (!ok) throw StateError('Failed to save preferences');
  }
}
