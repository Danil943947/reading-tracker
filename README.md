# Reading Tracker — Days 1–7 offline prototype

A personal reading tracker: discover books, save reading plans, log pages and notes,
and review your statistics. Built for a Flutter university final project.

## Getting started (macOS, VS Code)

Open the existing `reading_tracker` directory in VS Code. Run:

```bash
flutter pub get
flutter run --dart-define=USE_FAKES=true
```

The fake mode is offline. Demo login: **reader@example.com** / **password123**.
The credentials are intentionally public and only work in the local fake repository.
Do not use them as real credentials.

After changing dependencies, regenerate the lockfile on your computer using `flutter pub get`.

## Checks

```bash
dart format lib test
flutter analyze
flutter test
```

**Verification status:** Source files and imports were inspected in the artifact-building
environment. Flutter SDK was not installed there; the commands above MUST be run on your Mac.
Do not claim that a test or build passed until the local output confirms it.

## Navigation (9 screens)

Login → Discover → Book details → Add form; My Library → Entry details → Edit form;
Statistics; Settings → About. A persistent bottom bar connects four main tabs.

## Architecture (five lines)

- `lib/core/`: navigation, environment, exception types, shared widgets, secure storage.
- `lib/features/catalogue/`: immutable Book and Author models, fake search, state, list and detail.
- `lib/features/collection/`: ReadingEntry CRUD with local persistence, joined ReadingBook, stats, forms.
- `lib/features/auth/`: fake login plus secure token persistence and startup auth gate.
- `lib/features/profile/`: settings repository and ChangeNotifier with persistent theme and filter.

## Storage

- Login token: `flutter_secure_storage`; deleted on sign-out.
- Books/reading entries: fake repository persisted through `shared_preferences`.
- Theme and default filter: `shared_preferences`.
- Search catalogue: deterministic in-memory fake data, no network needed.
- Profile photo is a visual placeholder; camera/permission flow is **week 2 scope**.
- Real Open Library API, CRUD backend, file cache and signed APK are **week 2+ scope**.

## Current limitations

This is a course prototype, NOT the signed milestone release. `USE_FAKES=false` deliberately
throws a clear unsupported-mode error, rather than silently pretending the real API is connected.
In fake mode, the Open Library link is the only interaction that attempts to open the internet.
The catalogue and reading flows themselves do not use the network.

## Git and releases

Commit real completed work under your own identity. Do not invent a second contributor.
`v1.0.0` and `v1.1.0` should be published ONLY when the professor's release checklist
and signed Android APK are complete. See `TEAM.md` and `CHANGELOG.md`.

## Package notes and decisions

See `docs/packages.md` and `docs/decisions.md`.
