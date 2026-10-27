import '../../models/subject.dart';

String? validateSubjectName(
  String? value,
  List<Subject> subjects, {
  String? excludedSubjectId,
  required String duplicateMessage,
}) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) return 'Please enter a subject name.';

  final duplicateExists = subjects.any(
    (subject) =>
        subject.id != excludedSubjectId &&
        subject.name.toLowerCase() == name.toLowerCase(),
  );

  return duplicateExists ? duplicateMessage : null;
}
