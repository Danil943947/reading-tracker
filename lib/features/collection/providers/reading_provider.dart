import 'package:flutter/foundation.dart';
import '../../../core/state/load_status.dart';
import '../../catalogue/repositories/book_repository.dart';
import '../models/reading_book.dart';
import '../models/reading_entry.dart';
import '../models/reading_status.dart';
import '../repositories/reading_repository.dart';

enum LibrarySort { title, progress }

class ReadingProvider extends ChangeNotifier {
  ReadingProvider({required this.repository, required this.catalogue});
  final ReadingRepository repository;
  final BookRepository catalogue;

  List<ReadingBook> _items = const [];
  LoadStatus status = LoadStatus.initial;
  Object? error;
  bool isBusy = false;
  ReadingStatus? filter;
  LibrarySort sort = LibrarySort.title;
  int _request = 0;

  List<ReadingBook> get items => List.unmodifiable(_items);
  List<ReadingBook> get visibleItems {
    final values = _items.where((item) => filter == null || item.entry.status == filter).toList();
    if (sort == LibrarySort.title) {
      values.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else {
      values.sort((a, b) => b.progress.compareTo(a.progress));
    }
    return List.unmodifiable(values);
  }

  int get totalBooks => _items.length;
  int get completedBooks => _items.where((e) => e.entry.isCompleted).length;
  int get readingBooks => _items.where((e) => e.entry.status == ReadingStatus.reading).length;
  double get overallProgress {
    final total = _items.fold<int>(0, (n, e) => n + e.entry.totalPages);
    if (total == 0) return 0;
    final read = _items.fold<int>(0, (n, e) => n + e.entry.pagesRead);
    return (read * 100 / total).clamp(0, 100).toDouble();
  }
  bool containsBook(String bookId) => _items.any((item) => item.entry.bookId == bookId);

  void setFilter(ReadingStatus? value) { filter = value; notifyListeners(); }
  void setSort(LibrarySort value) { sort = value; notifyListeners(); }

  Future<void> load() async {
    final request = ++_request;
    status = LoadStatus.loading;
    error = null;
    notifyListeners();
    try {
      final entries = await repository.getAll();
      final books = await catalogue.searchBooks('');
      if (request != _request) return;
      final byId = {for (final book in books) book.id: book};
      _items = entries.map((entry) => ReadingBook(entry: entry, book: byId[entry.bookId])).toList();
      status = _items.isEmpty ? LoadStatus.empty : LoadStatus.data;
    } catch (e) {
      if (request != _request) return;
      error = e;
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<ReadingEntry?> save(ReadingEntry draft, {required bool editing}) async {
    if (isBusy) return null;
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      final saved = editing ? await repository.update(draft) : await repository.create(draft);
      await load();
      return saved;
    } catch (e) {
      error = e;
      notifyListeners();
      return null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> remove(String id) async {
    if (isBusy) return false;
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      await repository.delete(id);
      await load();
      return true;
    } catch (e) {
      error = e;
      notifyListeners();
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
