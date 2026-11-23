import '../../../core/api/api_exception.dart';
import '../models/author.dart';
import '../models/book.dart';
import 'book_repository.dart';

class FakeBookRepository implements BookRepository {
  FakeBookRepository({this.delay = const Duration(milliseconds: 180), this.shouldFail = false});
  final Duration delay;
  bool shouldFail;

  // Stable IDs let a collection entry refer to the matching catalogue book.
  static final List<Book> _seed = List.unmodifiable([
    Book(id: '/works/OL893415W', title: 'Dune', authors: const [Author(name: 'Frank Herbert')],
      firstPublishYear: 1965, description: 'On the desert world Arrakis, rival families struggle for control of a vital resource.',
      subjects: const ['Science fiction', 'Adventure'], language: 'eng'),
    Book(id: '/works/OL82563W', title: "Harry Potter and the Philosopher's Stone", authors: const [Author(name: 'J. K. Rowling')],
      firstPublishYear: 1997, description: 'A young wizard discovers Hogwarts and a hidden magical world.',
      subjects: const ['Fantasy', 'Magic'], language: 'eng'),
    Book(id: '/works/OL45804W', title: '1984', authors: const [Author(name: 'George Orwell')],
      firstPublishYear: 1949, description: 'A dystopian story about a society built on surveillance and control.',
      subjects: const ['Dystopia', 'Classics'], language: 'eng'),
    Book(id: '/works/OL27448W', title: 'The Lord of the Rings', authors: const [Author(name: 'J. R. R. Tolkien')],
      firstPublishYear: 1954, description: 'A fellowship sets out to destroy a dangerous ring.',
      subjects: const ['Fantasy', 'Epic'], language: 'eng'),
    Book(id: '/works/OL66554W', title: 'Pride and Prejudice', authors: const [Author(name: 'Jane Austen')],
      firstPublishYear: 1813, description: 'Elizabeth Bennet navigates family, expectations and love.',
      subjects: const ['Romance', 'Classics'], language: 'eng'),
    Book(id: '/works/OL262758W', title: 'The Hobbit', authors: const [Author(name: 'J. R. R. Tolkien')],
      firstPublishYear: 1937, description: 'Bilbo Baggins joins an unexpected adventure.',
      subjects: const ['Fantasy'], language: 'eng'),
    Book(id: '/works/OL6037022W', title: 'Fahrenheit 451', authors: const [Author(name: 'Ray Bradbury')],
      firstPublishYear: 1953, description: 'A fireman begins to question his society.',
      subjects: const ['Science fiction'], language: 'eng'),
    Book(id: '/works/OL14860373W', title: 'The Great Gatsby', authors: const [Author(name: 'F. Scott Fitzgerald')],
      firstPublishYear: 1925, description: 'A portrait of longing and wealth in the Jazz Age.',
      subjects: const ['Classics'], language: 'eng'),
  ]);

  Future<void> _wait() async {
    // A zero-delay fake request should complete using microtasks only.
    // Future.delayed(Duration.zero) creates a Timer and can block widget tests.
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (shouldFail) throw const NoConnectionException();
  }

  @override
  Future<List<Book>> searchBooks(String query) async {
    await _wait();
    final q = query.trim().toLowerCase();
    return List.unmodifiable(_seed.where((book) =>
      book.title.toLowerCase().contains(q) ||
      book.authors.any((author) => author.name.toLowerCase().contains(q))));
  }

  @override
  Future<Book?> getBookById(String id) async {
    await _wait();
    for (final book in _seed) {
      if (book.id == id) return book;
    }
    return null;
  }
}
