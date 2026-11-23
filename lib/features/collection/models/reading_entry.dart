import 'reading_status.dart';

class ReadingEntry {
  const ReadingEntry({
    required this.id,
    required this.bookId,
    required this.title,
    required this.status,
    required this.pagesRead,
    required this.totalPages,
    this.rating,
    this.notes,
    this.startDate,
    this.finishDate,
  });

  final String id;
  final String bookId;
  final String title;
  final ReadingStatus status;
  final int pagesRead;
  final int totalPages;
  final int? rating;
  final String? notes;
  final DateTime? startDate;
  final DateTime? finishDate;

  double get progressPercent => totalPages <= 0 ? 0 :
      (pagesRead * 100 / totalPages).clamp(0, 100).toDouble();
  bool get isCompleted => status == ReadingStatus.completed;

  // Kept in the model, not widgets, so rules can be unit tested.
  String? get validationError {
    if (bookId.isEmpty || title.trim().isEmpty) return 'A book is required.';
    if (totalPages < 1) return 'Total pages must be greater than zero.';
    if (pagesRead < 0 || pagesRead > totalPages) return 'Pages read must be between 0 and total pages.';
    if (rating case final int value) {
      if (value < 1 || value > 5) return 'Rating must be between 1 and 5.';
    }
    final start = startDate;
    final finish = finishDate;
    if (start != null && finish != null && finish.isBefore(start)) {
      return 'Finish date cannot be before start date.';
    }
    return null;
  }

  factory ReadingEntry.fromJson(Map<String, dynamic> json) => ReadingEntry(
    id: json['id'] as String,
    bookId: json['bookId'] as String,
    title: json['title'] as String,
    status: ReadingStatus.fromJson(json['status'] as String),
    pagesRead: (json['pagesRead'] as num).toInt(),
    totalPages: (json['totalPages'] as num).toInt(),
    rating: (json['rating'] as num?)?.toInt(),
    notes: json['notes'] as String?,
    startDate: json['startDate'] == null ? null : DateTime.parse(json['startDate'] as String),
    finishDate: json['finishDate'] == null ? null : DateTime.parse(json['finishDate'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'bookId': bookId, 'title': title, 'status': status.name,
    'pagesRead': pagesRead, 'totalPages': totalPages, 'rating': rating,
    'notes': notes, 'startDate': startDate?.toIso8601String(),
    'finishDate': finishDate?.toIso8601String(),
  };

  static const Object _keep = Object();
  ReadingEntry copyWith({
    String? id, String? bookId, String? title, ReadingStatus? status,
    int? pagesRead, int? totalPages, Object? rating = _keep,
    Object? notes = _keep, Object? startDate = _keep, Object? finishDate = _keep,
  }) => ReadingEntry(
    id: id ?? this.id, bookId: bookId ?? this.bookId, title: title ?? this.title,
    status: status ?? this.status, pagesRead: pagesRead ?? this.pagesRead,
    totalPages: totalPages ?? this.totalPages,
    rating: identical(rating, _keep) ? this.rating : rating as int?,
    notes: identical(notes, _keep) ? this.notes : notes as String?,
    startDate: identical(startDate, _keep) ? this.startDate : startDate as DateTime?,
    finishDate: identical(finishDate, _keep) ? this.finishDate : finishDate as DateTime?,
  );
}
