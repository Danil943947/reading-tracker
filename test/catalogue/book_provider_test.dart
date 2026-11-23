import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/core/state/load_status.dart';
import 'package:reading_tracker/features/catalogue/providers/book_provider.dart';
import 'package:reading_tracker/features/catalogue/repositories/fake_book_repository.dart';

void main() {
  test('loading becomes data', () async {
    final provider = BookProvider(repository: FakeBookRepository(delay: Duration.zero));
    await provider.searchBooks('Dune');
    expect(provider.status, LoadStatus.data);
    expect(provider.books.single.title, 'Dune');
    provider.dispose();
  });
  test('unknown query becomes empty', () async {
    final provider = BookProvider(repository: FakeBookRepository(delay: Duration.zero));
    await provider.searchBooks('not-present');
    expect(provider.status, LoadStatus.empty);
    provider.dispose();
  });
  test('connection failure becomes error', () async {
    final provider = BookProvider(repository: FakeBookRepository(delay: Duration.zero, shouldFail: true));
    await provider.searchBooks('');
    expect(provider.status, LoadStatus.error);
    provider.dispose();
  });
}
