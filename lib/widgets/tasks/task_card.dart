import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Subject subject;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.subject,
    required this.onTap,
  });

  static const Color _cardColor = Color(0xFFF3F7FE);
  static const Color _borderColor = Color(0xFFB5CCE8);

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
      color: _cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _borderColor, width: 1.4),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          child: Icon(Icons.assignment_outlined),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(subject.name),
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
            const Icon(Icons.arrow_forward),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
