import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/core/api/api_exception.dart';
import 'package:reading_tracker/features/catalogue/repositories/fake_book_repository.dart';

void main() {
  late FakeBookRepository repo;
  setUp(() { repo = FakeBookRepository(delay: Duration.zero); });
  test('search title, case insensitive', () async {
    final result = await repo.searchBooks('DUNE');
    expect(result.single.title, 'Dune');
  });
  test('search author', () async {
    final result = await repo.searchBooks('Orwell');
    expect(result.single.title, '1984');
  });
  test('unknown query is empty', () async {
    expect(await repo.searchBooks('definitely-unknown-123'), isEmpty);
  });
  test('getById finds specific book', () async {
    expect((await repo.getBookById('/works/OL893415W'))?.title, 'Dune');
  });
  test('getById returns null if absent', () async {
    expect(await repo.getBookById('missing'), isNull);
  });
  test('failure can be triggered deterministically', () async {
    repo.shouldFail = true;
    expect(repo.searchBooks(''), throwsA(isA<NoConnectionException>()));
  });
}
