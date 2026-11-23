import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/navigation/app_routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final signingOut = context.select<AuthProvider, bool>((a) => a.isBusy);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(18), children: [
        const Center(child: CircleAvatar(radius: 42, child: Icon(Icons.person_outline, size: 48))),
        const SizedBox(height: 8),
        const Center(child: Text('Offline reader profile')),
        const SizedBox(height: 22),
        Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const ThemeSelector(),
        const SizedBox(height: 24),
        Text('Default library filter', style: Theme.of(context).textTheme.titleLarge),
        DropdownButton<String>(value: settings.defaultFilter, isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All books')),
            DropdownMenuItem(value: 'wantToRead', child: Text('Want to Read')),
            DropdownMenuItem(value: 'reading', child: Text('Reading')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
          ],
          onChanged: (value) {
            if (value != null) context.read<SettingsProvider>().setDefaultFilter(value);
          }),
        const SizedBox(height: 14),
        ListTile(leading: const Icon(Icons.info_outline), title: const Text('About Reading Tracker'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, AppRoutes.about)),
        const Divider(),
        OutlinedButton.icon(onPressed: signingOut ? null : () => context.read<AuthProvider>().signOut(),
          icon: const Icon(Icons.logout), label: Text(signingOut ? 'Signing out...' : 'Sign out')),
      ]),
    );
  }
}
