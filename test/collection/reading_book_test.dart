import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/features/catalogue/models/book.dart';
import 'package:reading_tracker/features/collection/models/reading_book.dart';
import 'package:reading_tracker/features/collection/models/reading_entry.dart';
import 'package:reading_tracker/features/collection/models/reading_status.dart';

void main() {
  test('joins catalogue title with collection progress', () {
    const entry = ReadingEntry(id: '1', bookId: 'b', title: 'Old title',
      status: ReadingStatus.reading, pagesRead: 20, totalPages: 100);
    final joined = ReadingBook(entry: entry, book: Book(id: 'b', title: 'New catalogue title'));
    expect(joined.title, 'New catalogue title');
    expect(joined.progress, 20);
  });
}
