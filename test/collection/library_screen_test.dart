import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_tracker/features/catalogue/repositories/fake_book_repository.dart';
import 'package:reading_tracker/features/collection/providers/reading_provider.dart';
import 'package:reading_tracker/features/collection/repositories/fake_reading_repository.dart';
import 'package:reading_tracker/features/collection/screens/library_screen.dart';

void main() {
  testWidgets('library error has Retry that recovers', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    // Zero-delay fakes never schedule a Timer in widget tests.
    final repository = FakeReadingRepository(
      preferences: preferences,
      delay: Duration.zero,
      shouldFail: true,
    );
    final provider = ReadingProvider(
      repository: repository,
      catalogue: FakeBookRepository(delay: Duration.zero),
    );

    // First mount the widget tree. Then trigger and render the failure.
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );
    unawaited(provider.load());
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Offline. Connect and try again.'), findsOneWidget);

    // The user retries after the repository recovers.
    repository.shouldFail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('1984'), findsOneWidget);
    expect(provider.totalBooks, 2);

    // Remove all listeners before disposing the provider.
    await tester.pumpWidget(const SizedBox.shrink());
    provider.dispose();
  });
}
