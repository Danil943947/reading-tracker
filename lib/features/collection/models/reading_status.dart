enum ReadingStatus {
  wantToRead,
  reading,
  completed;

  String get label => switch (this) {
    ReadingStatus.wantToRead => 'Want to Read',
    ReadingStatus.reading => 'Reading',
    ReadingStatus.completed => 'Completed',
  };

  static ReadingStatus fromJson(String value) => ReadingStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => throw FormatException('Unknown reading status: $value'),
  );
}
