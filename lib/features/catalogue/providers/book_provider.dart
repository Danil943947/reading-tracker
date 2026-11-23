import 'package:flutter/foundation.dart';
import '../../../core/state/load_status.dart';
import '../models/book.dart';
import '../repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  BookProvider({required this.repository});
  final BookRepository repository;

  List<Book> _books = const [];
  LoadStatus _status = LoadStatus.initial;
  Object? _error;
  String _query = '';
  int _request = 0;

  List<Book> get books => List.unmodifiable(_books);
  LoadStatus get status => _status;
  Object? get error => _error;
  String get query => _query;

  Future<void> searchBooks(String query) async {
    _query = query;
    final current = ++_request;
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final result = await repository.searchBooks(query);
      if (current != _request) return; // Ignore an out-of-order response.
      _books = result;
      _status = result.isEmpty ? LoadStatus.empty : LoadStatus.data;
    } catch (error) {
      if (current != _request) return;
      _books = const [];
      _error = error;
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => searchBooks(_query);
}
