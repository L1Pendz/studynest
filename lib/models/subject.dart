class Subject {
  static const String noSubjectId = '__no_subject__';
  static const String noSubjectName = 'No Subject';

  final String id;
  final String name;
  final String description;

  bool get isNoSubject => id == noSubjectId;

  const Subject({required this.id, required this.name, this.description = ''});

  Subject copyWith({String? name, String? description}) {
    return Subject(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
