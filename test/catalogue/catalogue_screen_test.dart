import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reading_tracker/features/catalogue/providers/book_provider.dart';
import 'package:reading_tracker/features/catalogue/repositories/fake_book_repository.dart';
import 'package:reading_tracker/features/catalogue/screens/catalogue_screen.dart';

void main() {
  testWidgets('error state has working Retry', (tester) async {
    final repo = FakeBookRepository(delay: Duration.zero, shouldFail: true);
    final provider = BookProvider(repository: repo);
    await tester.pumpWidget(ChangeNotifierProvider.value(value: provider,
      child: const MaterialApp(home: CatalogueScreen())));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    repo.shouldFail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Dune'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
    provider.dispose();
  });
}
