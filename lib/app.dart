import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/navigation/app_routes.dart';
import 'core/navigation/main_shell.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/catalogue/models/book.dart';
import 'features/catalogue/screens/book_details_screen.dart';
import 'features/collection/models/reading_book.dart';
import 'features/collection/screens/reading_entry_details_screen.dart';
import 'features/collection/screens/reading_entry_form_screen.dart';
import 'features/profile/providers/settings_provider.dart';
import 'features/profile/screens/about_screen.dart';

class ReadingTrackerApp extends StatelessWidget {
  const ReadingTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<SettingsProvider>().themeMode;
    return MaterialApp(
      title: 'Reading Tracker', debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF375E70)),
        useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFF5F7F8)),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF7DA8B9), brightness: Brightness.dark), useMaterial3: true),
      themeMode: themeMode,
      home: const _AuthGate(),
      onGenerateRoute: _route,
    );
  }

  Route<dynamic>? _route(RouteSettings settings) {
    final args = settings.arguments;
    final Widget? page = switch (settings.name) {
      AppRoutes.bookDetails when args is Book => BookDetailsScreen(book: args),
      AppRoutes.entryDetails when args is ReadingBook => ReadingEntryDetailsScreen(readingBook: args),
      AppRoutes.entryForm when args is Book => ReadingEntryFormScreen(book: args),
      AppRoutes.entryForm when args is ReadingBook => ReadingEntryFormScreen(
        book: args.book ?? Book(id: args.entry.bookId, title: args.entry.title),
        existing: args.entry),
      AppRoutes.about => const AboutScreen(),
      _ => null,
    };
    if (page == null) return null;
    return MaterialPageRoute<dynamic>(builder: (_) => page, settings: settings);
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context) {
    final signedIn = context.watch<AuthProvider>().isSignedIn;
    return signedIn ? const MainShell() : const LoginScreen();
  }
}
