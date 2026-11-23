# Reading Tracker — Days 1–7 corrected source archive

This archive preserves the original nine-screen offline prototype and its platform projects.

## Corrections

- `FakeReadingRepository` and `FakeBookRepository` skip `Future.delayed` when delay is `Duration.zero`. Previously this scheduled an event-loop Timer that could deadlock a `testWidgets` pre-load.
- `FakeAuthRepository` applies the same zero-delay rule for deterministic widget tests.
- `library_screen_test.dart` mounts the widget before invoking `ReadingProvider.load()`, tests the error UI, presses Retry and checks that the saved book appears.
- Removed duplicate security ignore entries from `.gitignore`.

## What has been checked here

- Source-tree presence, local Dart import paths and ZIP content integrity.
- Package configuration and test file presence.

**Not yet verified in this environment:** actual `flutter analyze`, `flutter test` or a GUI runtime. The Flutter SDK is unavailable here. Execute these on the target Mac; do not treat the test suite as green until it finishes there.

## macOS / VS Code

1. Back up your current `~/Developer/reading_tracker` directory.
2. Extract this ZIP to a **new directory**; do not overwrite your old files until verified.
3. Open the extracted `reading_tracker` folder in VS Code and run:

```sh
flutter pub get
flutter analyze
flutter test test/collection/library_screen_test.dart --reporter expanded --timeout 15s
flutter test --reporter expanded --timeout 15s
flutter run -d chrome --dart-define=USE_FAKES=true
```

Offline test sign-in: reader@example.com / password123.

If a command reports a failure, send the **first actual error with stack trace**, not just a screenshot of the elapsed test counter.
