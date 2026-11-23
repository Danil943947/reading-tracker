import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_tracker/core/state/load_status.dart';
import 'package:reading_tracker/features/catalogue/repositories/fake_book_repository.dart';
import 'package:reading_tracker/features/collection/models/reading_entry.dart';
import 'package:reading_tracker/features/collection/models/reading_status.dart';
import 'package:reading_tracker/features/collection/providers/reading_provider.dart';
import 'package:reading_tracker/features/collection/repositories/fake_reading_repository.dart';

void main() {
  late FakeReadingRepository repository;
  late ReadingProvider provider;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = FakeReadingRepository(preferences: prefs, delay: Duration.zero);
    provider = ReadingProvider(repository: repository,
      catalogue: FakeBookRepository(delay: Duration.zero));
  });
  tearDown(() => provider.dispose());
  test('loaded collection has computed statistics', () async {
    await provider.load();
    expect(provider.status, LoadStatus.data);
    expect(provider.totalBooks, 2);
    expect(provider.completedBooks, 1);
    expect(provider.readingBooks, 1);
  });
  test('filter shows only selected status', () async {
    await provider.load();
    provider.setFilter(ReadingStatus.completed);
    expect(provider.visibleItems.length, 1);
  });
  test('save triggers repository and refresh', () async {
    await provider.load();
    const entry = ReadingEntry(id: '', bookId: '/works/OL893415W', title: 'Dune',
      status: ReadingStatus.wantToRead, pagesRead: 0, totalPages: 400);
    expect(await provider.save(entry, editing: false), isNotNull);
    expect(provider.totalBooks, 3);
  });
  test('repository failure becomes error state', () async {
    repository.shouldFail = true;
    await provider.load();
    expect(provider.status, LoadStatus.error);
  });
}
