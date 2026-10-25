enum StudyMaterialType { document, link }

class StudyMaterial {
  final String id;
  final String title;
  final String subjectId;
  final String description;
  final StudyMaterialType type;
  final String resourceLocation;
  final String? fileName;
  final DateTime addedAt;

  const StudyMaterial({
    required this.id,
    required this.title,
    required this.subjectId,
    this.description = '',
    required this.type,
    required this.resourceLocation,
    this.fileName,
    required this.addedAt,
  });
}
