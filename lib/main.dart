import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/env.dart';
import 'core/storage/secure_token_store.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/repositories/fake_auth_repository.dart';
import 'features/catalogue/providers/book_provider.dart';
import 'features/catalogue/repositories/fake_book_repository.dart';
import 'features/collection/models/reading_status.dart';
import 'features/collection/providers/reading_provider.dart';
import 'features/collection/repositories/fake_reading_repository.dart';
import 'features/profile/providers/settings_provider.dart';
import 'features/profile/repositories/preferences_settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Env.useFakes) {
    throw UnsupportedError('Real API mode is planned for week 2. Use --dart-define=USE_FAKES=true.');
  }

  final preferences = await SharedPreferences.getInstance();
  final catalogue = FakeBookRepository();
  final collection = FakeReadingRepository(preferences: preferences);
  final auth = AuthProvider(
    repository: FakeAuthRepository(),
    tokens: SecureTokenStore(const FlutterSecureStorage()),
  );
  final settings = SettingsProvider(PreferencesSettingsRepository(preferences));
  await Future.wait([auth.restoreSession(), settings.initialize()]);

  final reading = ReadingProvider(repository: collection, catalogue: catalogue);
  final filterName = settings.defaultFilter;
  for (final status in ReadingStatus.values) {
    if (filterName == status.name) reading.setFilter(status);
  }
  await reading.load();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => BookProvider(repository: catalogue)),
    ChangeNotifierProvider.value(value: reading),
    ChangeNotifierProvider.value(value: auth),
    ChangeNotifierProvider.value(value: settings),
  ], child: const ReadingTrackerApp()));
}
