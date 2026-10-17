import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  final List<Subject> subjects;
  final VoidCallback onDelete;
  final ValueChanged<Task> onUpdate;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.subjects,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Center(child: Text(task.title)),
    );
  }
}
