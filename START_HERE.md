# Reading Tracker — first launch on Mac

This is a **Days 1–7 offline prototype** built from your previously uploaded Flutter project.
It is **not** the signed v1.0.0 milestone.

## Install without overwriting your old work

1. In Finder, make a backup of your current `~/Developer/reading_tracker` folder
   (for example, copy it to `reading_tracker_before_days_1_7`).
2. Extract this ZIP. It contains a new root folder named `reading_tracker`.
3. Move that extracted folder into `~/Developer` **after** safely renaming/moving the
   older `reading_tracker` folder. Avoid nesting `reading_tracker/reading_tracker`.
4. Open the new folder in VS Code using `File → Open Folder`.
5. Run the following commands **one at a time** from the VS Code terminal:

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=USE_FAKES=true
```

`flutter pub get` will update the original `pubspec.lock`, because we added
new packages. Commit that updated lockfile to GitHub with the source files.

## Login

Email: `reader@example.com`  
Password: `password123`

The credentials are **only for the fake demo**. The catalog, library, statistics
and settings work without a server. The external Open Library link optionally
opens a web browser and will need the internet.

## Exercise the main flow

1. Sign in.
2. Discover → open Dune → Add to My Library.
3. Enter total pages and pages read → Save.
4. My Library → open Dune → Edit → update progress.
5. Statistics → check counts and overall progress.
6. Settings → change to Dark → restart app → verify theme persists.
7. Settings → Sign out → reopen → verify Login screen appears.
8. Search an impossible book title to see empty state; pull down to refresh.

## Troubleshooting

If VS Code highlights new dependencies in red, run `flutter pub get` in the
new folder first. If errors remain, copy the **first** error from `flutter analyze`.

This archive was assembled and subjected to text-level checks in an environment
without Flutter/Dart SDK. No claim of successful local build or green tests is
made until you execute the commands on your Mac.
