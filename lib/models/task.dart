enum TaskUrgency { low, medium, high, critical }

class Task {
  final String id;
  final String title;
  final String subjectId;
  final String description;
  final DateTime dueDate;

  final Duration mediumThreshold;
  final Duration highThreshold;
  final Duration criticalThreshold;

  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.subjectId,
    this.description = '',
    required this.dueDate,
    this.mediumThreshold = const Duration(days: 7),
    this.highThreshold = const Duration(days: 3),
    this.criticalThreshold = const Duration(days: 1),
    this.isCompleted = false,
  });

  TaskUrgency get urgency {
    final remaining = dueDate.difference(DateTime.now());

    if (remaining <= criticalThreshold) {
      return TaskUrgency.critical;
    }

    if (remaining <= highThreshold) {
      return TaskUrgency.high;
    }

    if (remaining <= mediumThreshold) {
      return TaskUrgency.medium;
    }

    return TaskUrgency.low;
  }

  Task copyWith({
    String? title,
    String? subjectId,
    String? description,
    DateTime? dueDate,
    Duration? mediumThreshold,
    Duration? highThreshold,
    Duration? criticalThreshold,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      mediumThreshold: mediumThreshold ?? this.mediumThreshold,
      highThreshold: highThreshold ?? this.highThreshold,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
