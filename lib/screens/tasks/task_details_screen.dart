import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';
import 'task_form_screen.dart';

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

  Subject? get _subject {
    for (final subject in subjects) {
      if (subject.id == task.subjectId) {
        return subject;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final subject = _subject;

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTaskTitle(),
          const SizedBox(height: 24),
          _buildDetail(
            label: 'Subject',
            value: subject?.name ?? 'Unknown subject',
          ),
          const SizedBox(height: 20),
          _buildDetail(label: 'Description', value: task.description),
          const SizedBox(height: 20),
          _buildDetail(
            label: 'Deadline',
            value:
                '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
          ),
          const SizedBox(height: 20),
          _buildUrgency(),
          const SizedBox(height: 20),
          _buildThresholds(),
          const SizedBox(height: 30),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildTaskTitle() {
    return Text(
      task.title,
      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildUrgency() {
    final urgency = task.urgency;

    return _buildDetail(label: 'Urgency', value: _urgencyLabel(urgency));
  }

  Widget _buildThresholds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Urgency Thresholds',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        Text('Medium: ${task.mediumThreshold.inDays} days'),
        Text('High: ${task.highThreshold.inDays} days'),
        Text('Critical: ${task.criticalThreshold.inDays} day'),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final updatedTask = await Navigator.push<Task>(
                context,
                MaterialPageRoute<Task>(
                  builder: (_) =>
                      TaskFormScreen(task: task, subjects: subjects),
                ),
              );

              if (!context.mounted || updatedTask == null) return;

              onUpdate(updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Edit Task'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              // Delete functionality will be implemented next.
            },
            child: const Text('Delete Task'),
          ),
        ),
      ],
    );
  }

  String _urgencyLabel(TaskUrgency urgency) {
    switch (urgency) {
      case TaskUrgency.low:
        return 'Low';
      case TaskUrgency.medium:
        return 'Medium';
      case TaskUrgency.high:
        return 'High';
      case TaskUrgency.critical:
        return 'Critical';
    }
  }
}
