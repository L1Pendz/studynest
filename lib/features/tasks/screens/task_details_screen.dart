import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studynest/utils/subject_lookup.dart';

import '../../../models/subject.dart';
import '../../../models/task.dart';
import 'task_form_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final List<Subject> subjects;
  final Future<void> Function() onDelete;
  final Future<void> Function(Task) onUpdate;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.subjects,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  Timer? _urgencyTimer;

  static const Color _cardColor = Color(0xFFF3F7FE);
  static const Color _borderColor = Color(0xFFB5CCE8);
  static const Color _primaryColor = Color(0xFF8EC9F5);

  @override
  void initState() {
    super.initState();

    _urgencyTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _urgencyTimer?.cancel();
    super.dispose();
  }

  Subject? get _subject {
    return findSubjectById(widget.subjects, widget.task.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    final subject = _subject;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: Colors.black87),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                children: [
                  _buildTaskCard(),
                  const SizedBox(height: 24),
                  _buildDetail(
                    label: 'Subject',
                    value: subject?.name ?? 'Unknown subject',
                  ),
                  const SizedBox(height: 20),
                  _buildDetail(
                    label: 'Description',
                    value: widget.task.description,
                  ),
                  const SizedBox(height: 20),
                  _buildDetail(
                    label: 'Deadline',
                    value:
                        '${_monthName(widget.task.dueDate.month)} ${widget.task.dueDate.day}, ${widget.task.dueDate.year}',
                  ),

                  const SizedBox(height: 20),
                  _buildThresholds(),
                  const SizedBox(height: 30),
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Task Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTaskCard() {
    final urgencyColor = _urgencyColor(widget.task.urgency);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1.4),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            child: Icon(Icons.assignment_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: urgencyColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _urgencyLabel(widget.task.urgency),
              style: TextStyle(
                color: urgencyColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }

  Widget _buildThresholds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency Thresholds',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          'Medium: ${widget.task.mediumThreshold.inDays} days\n'
          'High: ${widget.task.highThreshold.inDays} days\n'
          'Critical: ${widget.task.criticalThreshold.inDays} days',
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.black87,
              elevation: 0,
              side: const BorderSide(color: Colors.black87, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final updatedTask = await Navigator.push<Task>(
                context,
                MaterialPageRoute<Task>(
                  builder: (_) => TaskFormScreen(
                    task: widget.task,
                    subjects: widget.subjects,
                  ),
                ),
              );

              if (!context.mounted || updatedTask == null) return;

              try {
                await widget.onUpdate(updatedTask);
                if (context.mounted) Navigator.pop(context);
              } catch (_) {
                _showStorageError();
              }
            },
            child: const Text(
              'Edit Task',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _confirmDelete(context),
            child: const Text(
              'Delete Task',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: const Text(
            'Are you sure you want to delete this task? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await widget.onDelete();
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      _showStorageError();
    }
  }

  void _showStorageError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not save the task. Try again.')),
    );
  }

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

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}
