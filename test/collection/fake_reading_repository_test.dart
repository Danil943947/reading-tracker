import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_tracker/core/api/api_exception.dart';
import 'package:reading_tracker/features/collection/models/reading_entry.dart';
import 'package:reading_tracker/features/collection/models/reading_status.dart';
import 'package:reading_tracker/features/collection/repositories/fake_reading_repository.dart';

void main() {
  late SharedPreferences prefs;
  late FakeReadingRepository repo;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = FakeReadingRepository(preferences: prefs, delay: Duration.zero);
  });
  const draft = ReadingEntry(id: '', bookId: 'new-book', title: 'New',
    status: ReadingStatus.wantToRead, pagesRead: 0, totalPages: 100);
  test('starts with predictable collection', () async {
    expect((await repo.getAll()).length, 2);
  });
  test('create and getById', () async {
    final created = await repo.create(draft);
    expect(created.id, 'local-1');
    expect((await repo.getById(created.id))?.title, 'New');
  });
  test('update persists and returns updated entry', () async {
    final created = await repo.create(draft);
    await repo.update(created.copyWith(pagesRead: 77));
    expect((await repo.getById(created.id))?.pagesRead, 77);
  });
  test('delete removes entry', () async {
    final created = await repo.create(draft);
    await repo.delete(created.id);
    expect(await repo.getById(created.id), isNull);
  });
  test('duplicate book is prohibited', () async {
    await repo.create(draft);
    expect(repo.create(draft), throwsA(isA<RequestException>()));
  });
  test('data survives repository reconstruction', () async {
    await repo.create(draft);
    final reopened = FakeReadingRepository(preferences: prefs, delay: Duration.zero);
    expect((await reopened.getAll()).length, 3);
  });
  test('simulated error reaches caller', () async {
    repo.shouldFail = true;
    expect(repo.getAll(), throwsA(isA<NoConnectionException>()));
  });
}
