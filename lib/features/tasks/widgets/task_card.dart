import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Subject subject;
  final VoidCallback onTap;
  final ValueChanged<bool> onCompletionChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.subject,
    required this.onTap,
    required this.onCompletionChanged,
  });

  Color _urgencyColor(TaskUrgency urgency) {
    switch (urgency) {
      case TaskUrgency.low:
        return Colors.green;
      case TaskUrgency.medium:
        return Colors.yellow.shade700;
      case TaskUrgency.high:
        return Colors.orange;
      case TaskUrgency.critical:
        return Colors.red;
    }
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

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _urgencyColor(task.urgency);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            if (value != null) {
              onCompletionChanged(value);
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${subject.name} - Due ${task.dueDate.month}/${task.dueDate.day}/${task.dueDate.year}',
          style: const TextStyle(color: AppTheme.mutedInk, height: 1.45),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: urgencyColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _urgencyLabel(task.urgency),
                style: TextStyle(
                  color: urgencyColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.mutedInk,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
