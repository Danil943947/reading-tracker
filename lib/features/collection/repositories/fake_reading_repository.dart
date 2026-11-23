import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_exception.dart';
import '../models/reading_entry.dart';
import '../models/reading_status.dart';
import 'reading_repository.dart';

// Offline CRUD persisted in preferences. Replace with HTTP repository in week 2.
class FakeReadingRepository implements ReadingRepository {
  FakeReadingRepository({required this._preferences,
      this.delay = const Duration(milliseconds: 180), this.shouldFail = false});
  final SharedPreferences _preferences;
  final Duration delay;
  bool shouldFail;
  static const _key = 'reading_tracker_entries_v1';
  List<ReadingEntry>? _cache;

  static final List<ReadingEntry> _seed = [
    ReadingEntry(id: 'seed-1', bookId: '/works/OL45804W', title: '1984',
      status: ReadingStatus.completed, pagesRead: 328, totalPages: 328, rating: 5),
    ReadingEntry(id: 'seed-2', bookId: '/works/OL66554W', title: 'Pride and Prejudice',
      status: ReadingStatus.reading, pagesRead: 120, totalPages: 432),
  ];

  Future<void> _wait() async {
    // A zero-delay fake request should complete using microtasks only.
    // Future.delayed(Duration.zero) creates a Timer and can block widget tests.
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (shouldFail) throw const NoConnectionException();
  }

  List<ReadingEntry> _read() {
    if (_cache case final List<ReadingEntry> cached) return cached;
    final stored = _preferences.getString(_key);
    if (stored == null) {
      _cache = List.of(_seed);
    } else {
      try {
        final decoded = jsonDecode(stored) as List<dynamic>;
        _cache = decoded.map((e) => ReadingEntry.fromJson(e as Map<String, dynamic>)).toList();
      } on FormatException catch (error) {
        throw BadResponseException('collection: $error');
      } on TypeError catch (error) {
        throw BadResponseException('collection: $error');
      }
    }
    return _cache ?? const [];
  }

  Future<void> _persist(List<ReadingEntry> updated) async {
    final json = jsonEncode(updated.map((e) => e.toJson()).toList());
    final saved = await _preferences.setString(_key, json);
    if (!saved) throw const RequestException('Unable to save collection locally.');
    _cache = updated;
  }

  @override
  Future<List<ReadingEntry>> getAll() async {
    await _wait();
    return List.unmodifiable(_read());
  }

  @override
  Future<ReadingEntry?> getById(String id) async {
    await _wait();
    for (final entry in _read()) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  @override
  Future<ReadingEntry> create(ReadingEntry draft) async {
    await _wait();
    if (draft.validationError case final String problem) throw RequestException(problem);
    final current = _read();
    if (current.any((e) => e.bookId == draft.bookId)) {
      throw const RequestException('This book is already in your library.');
    }
    var next = 1;
    while (current.any((e) => e.id == 'local-$next')) { next++; }
    final saved = draft.copyWith(id: 'local-$next');
    await _persist([...current, saved]);
    return saved;
  }

  @override
  Future<ReadingEntry> update(ReadingEntry entry) async {
    await _wait();
    if (entry.validationError case final String problem) throw RequestException(problem);
    final current = _read();
    final index = current.indexWhere((e) => e.id == entry.id);
    if (index < 0) throw const NotFoundException();
    if (current.any((e) => e.id != entry.id && e.bookId == entry.bookId)) {
      throw const RequestException('This book is already in your library.');
    }
    final updated = [...current];
    updated[index] = entry;
    await _persist(updated);
    return entry;
  }

  @override
  Future<void> delete(String id) async {
    await _wait();
    final current = _read();
    if (!current.any((e) => e.id == id)) throw const NotFoundException();
    await _persist(current.where((e) => e.id != id).toList());
  }
}
