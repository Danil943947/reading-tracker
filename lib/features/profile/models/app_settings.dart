import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({this.themeMode = ThemeMode.system, this.defaultFilter = 'all'});
  final ThemeMode themeMode;
  final String defaultFilter;

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    themeMode: ThemeMode.values.firstWhere(
      (mode) => mode.name == json['themeMode'], orElse: () => ThemeMode.system,
    ),
    defaultFilter: const ['all', 'wantToRead', 'reading', 'completed'].contains(json['defaultFilter'])
      ? json['defaultFilter'] as String : 'all',
  );
  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name, 'defaultFilter': defaultFilter,
  };
  AppSettings copyWith({ThemeMode? themeMode, String? defaultFilter}) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    defaultFilter: defaultFilter ?? this.defaultFilter,
  );
}
