class Env {
  const Env._();

  // One place for compile-time settings. Fake mode is the safe default.
  static const bool useFakes = bool.fromEnvironment('USE_FAKES', defaultValue: true);
  static const String name = String.fromEnvironment('APP_ENV', defaultValue: 'development');
  static const String host = String.fromEnvironment('API_HOST', defaultValue: 'openlibrary.org');
}
