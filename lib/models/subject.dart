class Subject {
  final String id;
  final String name;
  final String description;

  const Subject({
    required this.id,
    required this.name,
    this.description = '',
  });

  Subject copyWith({
    String? name,
    String? description,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}