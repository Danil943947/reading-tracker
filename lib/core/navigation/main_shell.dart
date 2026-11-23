import 'package:flutter/material.dart';
import '../../features/catalogue/screens/catalogue_screen.dart';
import '../../features/collection/screens/library_screen.dart';
import '../../features/collection/screens/statistics_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _index, children: const [
      CatalogueScreen(), LibraryScreen(), StatisticsScreen(), SettingsScreen(),
    ]),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _index,
      onDestinationSelected: (value) => setState(() => _index = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore), label: 'Discover'),
        NavigationDestination(icon: Icon(Icons.bookmark_border),
          selectedIcon: Icon(Icons.bookmark), label: 'My Library'),
        NavigationDestination(icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart), label: 'Statistics'),
        NavigationDestination(icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings), label: 'Settings'),
      ],
    ),
  );
}
