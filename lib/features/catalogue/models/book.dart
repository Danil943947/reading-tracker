import 'author.dart';

class Book {
  Book({
    required this.id,
    required this.title,
    List<Author> authors = const [],
    this.description,
    this.coverUrl,
    this.firstPublishYear,
    List<String> subjects = const [],
    this.language,
  })  : authors = List.unmodifiable(authors),
        subjects = List.unmodifiable(subjects);

  final String id;
  final String title;
  final List<Author> authors;
  final String? description;
  final String? coverUrl;
  final int? firstPublishYear;
  final List<String> subjects;
  final String? language;

  String get author => authors.isEmpty ? 'Unknown author' : authors.first.name;

  factory Book.fromJson(Map<String, dynamic> json) {
    final identifier = json['id'] ?? json['key'];
    if (identifier is! String) throw const FormatException('book.id must be text');
    final title = json['title'];
    if (title is! String) throw const FormatException('book.title must be text');
    final people = <Author>[];
    final rawAuthors = json['authors'];
    if (rawAuthors is List) {
      for (final item in rawAuthors) {
        if (item is Map<String, dynamic>) {
          people.add(Author.fromJson(item));
        } else if (item is String) {
          people.add(Author(name: item));
        }
      }
    }
    if (people.isEmpty && json['author_name'] is List) {
      for (final name in json['author_name'] as List) {
        if (name is String) people.add(Author(name: name));
      }
    }
    final rawSubjects = json['subjects'] ?? json['subject'];
    final rawDescription = json['description'];
    final rawLanguage = json['language'];
    final rawYear = json['firstPublishYear'] ?? json['first_publish_year'];
    final cover = json['coverUrl'] ?? json['cover_url'];
    return Book(
      id: identifier,
      title: title,
      authors: people,
      description: rawDescription is String
          ? rawDescription
          : rawDescription is Map ? rawDescription['value'] as String? : null,
      coverUrl: cover is String ? cover : null,
      firstPublishYear: rawYear is num ? rawYear.toInt() : null,
      subjects: rawSubjects is List ? rawSubjects.whereType<String>().toList() : const [],
      language: rawLanguage is String
          ? rawLanguage
          : rawLanguage is List && rawLanguage.isNotEmpty && rawLanguage.first is String
              ? rawLanguage.first as String
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors.map((a) => a.toJson()).toList(),
        'description': description,
        'coverUrl': coverUrl,
        'firstPublishYear': firstPublishYear,
        'subjects': subjects.toList(),
        'language': language,
      };

  static const Object _keep = Object();
  Book copyWith({
    String? id,
    String? title,
    List<Author>? authors,
    Object? description = _keep,
    Object? coverUrl = _keep,
    Object? firstPublishYear = _keep,
    List<String>? subjects,
    Object? language = _keep,
  }) => Book(
        id: id ?? this.id,
        title: title ?? this.title,
        authors: authors ?? this.authors,
        description: identical(description, _keep) ? this.description : description as String?,
        coverUrl: identical(coverUrl, _keep) ? this.coverUrl : coverUrl as String?,
        firstPublishYear: identical(firstPublishYear, _keep) ? this.firstPublishYear : firstPublishYear as int?,
        subjects: subjects ?? this.subjects,
        language: identical(language, _keep) ? this.language : language as String?,
      );
}
