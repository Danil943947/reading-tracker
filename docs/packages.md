# Dependencies (prototype)

Run `flutter pub outdated` and check official pub.dev pages on your Mac for the current
publisher, release dates and supported platforms before release (R33 requires this audit).

- `http`: Dart HTTP client, reserved for week 2 real API; MockClient supports offline tests.
- `provider`: Flutter community state-management helper; connects ChangeNotifier to widgets.
- `shared_preferences`: Flutter-supported persistent simple key-value store; used for settings and offline fake shelf.
- `flutter_secure_storage`: secure platform-backed key/value store for login token.
- `url_launcher`: Flutter-supported external link launcher for Open Library detail pages.
- `package_info_plus`: reads installed application version/build for About screen.
- `cupertino_icons`: generated Flutter starter dependency, retained for platform icons.
- `flutter_lints`: static analyzer lint rules, development only.
