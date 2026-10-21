import 'package:flutter/material.dart';
import 'package:studynest/screens/tasks/task_form_screen.dart';

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
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final updatedTask = await Navigator.push<Task>(
              context,
              MaterialPageRoute<Task>(
                builder: (_) => TaskFormScreen(task: task, subjects: subjects),
              ),
            );

            if (updatedTask == null) return;

            onUpdate(updatedTask);
          },
          child: const Text('Edit Task'),
        ),
      ),
    );
  }
}
