import 'package:flutter_test/flutter_test.dart';
import 'package:reading_tracker/features/collection/models/reading_entry.dart';
import 'package:reading_tracker/features/collection/models/reading_status.dart';

void main() {
  const entry = ReadingEntry(id: '1', bookId: 'b1', title: 'Dune',
    status: ReadingStatus.reading, pagesRead: 100, totalPages: 200, rating: 4);
  test('computes percentage', () => expect(entry.progressPercent, 50));
  test('progress clamps over 100', () => expect(entry.copyWith(pagesRead: 300).progressPercent, 100));
  test('invalid pages are rejected by rule', () => expect(entry.copyWith(pagesRead: 300).validationError, isNotNull));
  test('round trips JSON', () {
    final restored = ReadingEntry.fromJson(entry.toJson());
    expect(restored.status, ReadingStatus.reading);
    expect(restored.pagesRead, 100);
  });
  test('copyWith clears nullable rating', () => expect(entry.copyWith(rating: null).rating, isNull));
  test('invalid status throws', () {
    final json = entry.toJson()..['status'] = 'broken';
    expect(() => ReadingEntry.fromJson(json), throwsFormatException);
  });
  test('finish date before start is rejected', () {
    final bad = entry.copyWith(startDate: DateTime(2026, 4, 5), finishDate: DateTime(2026, 4, 4));
    expect(bad.validationError, isNotNull);
  });
}
