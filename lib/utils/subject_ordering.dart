import '../models/subject.dart';

List<Subject> orderSubjectsForPicker(List<Subject> subjects) => [
  ...subjects.where((subject) => subject.isNoSubject),
  ...subjects.where((subject) => !subject.isNoSubject),
];
