# Design decisions (Days 1–7)

1. Owner: individual student. Use feature folders instead of grouping by widget type; reject a monolithic `lib/`.
2. Owner: individual student. Use `BookRepository` abstraction so data sources are swappable; reject HTTP in widgets.
3. Owner: individual student. Use deterministic fakes first; reject network dependency for the prototype.
4. Owner: individual student. Use immutable Book and ReadingEntry; reject mutating widget-held model state.
5. Owner: individual student. Use `ChangeNotifier` per feature; reject one global ChangeNotifier.
6. Owner: individual student. Use secure storage for auth token; reject `shared_preferences` for tokens.
7. Owner: individual student. Persist the fake reading shelf in preferences; reject losing all changes on restart.
8. Owner: individual student. Keep settings ready before `runApp`; reject a theme flash on startup.
9. Owner: individual student. Join catalogue books and reading entries in `ReadingBook`; reject joining in widget `build`.
10. Owner: individual student. Validate page limits in the model as well as in the form; reject UI-only validation.
11. Owner: individual student. Ignore obsolete catalogue replies using request IDs; reject stale results overwriting new ones.
12. Owner: individual student. Mark real mode explicitly unsupported for this prototype; reject misleading silent fallback.
