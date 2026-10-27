import '../models/subject.dart';

Subject? findSubjectById(List<Subject> subjects, String? subjectId) {
  if (subjectId == null) return null;

  for (final subject in subjects) {
    if (subject.id == subjectId) return subject;
  }

  return null;
}
