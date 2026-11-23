import '../models/reading_entry.dart';

abstract interface class ReadingRepository {
  Future<List<ReadingEntry>> getAll();
  Future<ReadingEntry?> getById(String id);
  Future<ReadingEntry> create(ReadingEntry draft);
  Future<ReadingEntry> update(ReadingEntry entry);
  Future<void> delete(String id);
}
