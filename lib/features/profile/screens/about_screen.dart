import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/env.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('About')),
    body: FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) => ListView(padding: const EdgeInsets.all(20), children: [
        Icon(Icons.auto_stories, size: 72, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        Text('Reading Tracker', textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 24),
        _row('Version', snapshot.hasData
          ? '${snapshot.data?.version} (${snapshot.data?.buildNumber})' : 'Loading...'),
        _row('Build mode', Env.useFakes ? 'Fake repositories — offline' : 'Real API'),
        _row('Environment', Env.name),
        _row('API host', Env.useFakes ? 'No network requests' : Env.host),
        _row('Storage', 'Secure token + local preferences'),
      ]),
    ),
  );

  Widget _row(String label, String value) => ListTile(
    title: Text(label), subtitle: Text(value),
  );
}
