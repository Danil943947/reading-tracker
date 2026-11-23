import '../../catalogue/models/book.dart';
import 'reading_entry.dart';

// Joins the public catalogue model to the user's private collection record.
class ReadingBook {
  const ReadingBook({required this.entry, required this.book});
  final ReadingEntry entry;
  final Book? book;
  String get title => book?.title ?? entry.title;
  String get author => book?.author ?? 'Unknown author';
  double get progress => entry.progressPercent;
}
