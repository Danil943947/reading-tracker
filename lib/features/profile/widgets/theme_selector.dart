import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.select<SettingsProvider, ThemeMode>((s) => s.themeMode);
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.phone_android), label: Text('System')),
        ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
        ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
      ],
      selected: {theme},
      onSelectionChanged: (values) => context.read<SettingsProvider>().setTheme(values.first),
    );
  }
}
