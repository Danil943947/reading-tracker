import '../models/book.dart';

abstract interface class BookRepository {
  Future<List<Book>> searchBooks(String query);
  Future<Book?> getBookById(String id);
}
