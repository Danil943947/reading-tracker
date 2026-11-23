class Author {
  const Author({required this.name, this.key});
  final String name;
  final String? key;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json['name'] as String,
        key: json['key'] as String?,
      );

  Map<String, dynamic> toJson() => {'name': name, 'key': key};

  Author copyWith({String? name, String? key}) => Author(
        name: name ?? this.name,
        key: key ?? this.key,
      );
}
