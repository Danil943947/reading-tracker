import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/features/catalogue/models/author.dart';
import 'package:reading_tracker/features/catalogue/models/book.dart';

void main() {
  group('Book model', () {
    test('accepts nested authors and immutable lists', () {
      final book = Book(id: '1', title: 'Dune', authors: const [Author(name: 'Frank Herbert')]);
      expect(book.author, 'Frank Herbert');
      expect(() => book.authors.clear(), throwsUnsupportedError);
    });
    test('parses Open Library search response', () {
      final book = Book.fromJson({'key': '/works/1', 'title': '1984',
        'author_name': ['George Orwell'], 'first_publish_year': 1949, 'subject': ['Classics']});
      expect(book.author, 'George Orwell');
      expect(book.firstPublishYear, 1949);
      expect(book.subjects, ['Classics']);
    });
    test('round trips JSON with nested authors', () {
      final book = Book(id: '1', title: 'Dune',
        authors: const [Author(name: 'Frank Herbert', key: '/authors/12')],
        description: 'Description');
      final restored = Book.fromJson(book.toJson());
      expect(restored.authors.first.key, '/authors/12');
      expect(restored.description, 'Description');
    });
    test('copyWith does not mutate original', () {
      final book = Book(id: '1', title: 'Dune');
      expect(book.copyWith(title: 'New').title, 'New');
      expect(book.title, 'Dune');
    });
    test('rejects missing id', () {
      expect(() => Book.fromJson({'title': 'Dune'}), throwsFormatException);
    });
  });
}
