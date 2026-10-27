import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';

class HomeScreen extends StatelessWidget {
  final List<Subject> subjects;
  final List<Task> tasks;

  const HomeScreen({super.key, required this.subjects, required this.tasks});

  static const _summaryColors = [
    Color(0xFF9ED8FA),
    Color(0xFFFFC9CB),
    Color(0xFFFFE99C),
    Color(0xFFAEEFC1),
  ];

  @override
  Widget build(BuildContext context) {
    final regularSubjects = subjects.where((subject) => !subject.isNoSubject);
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;
    final dueToday = tasks.where((task) {
      if (task.isCompleted) return false;
      final now = DateTime.now();
      return task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).length;

    final summaries = [
      ('Total Tasks', tasks.length, _summaryColors[0]),
      ('Due Today', dueToday, _summaryColors[1]),
      ('Pending Tasks', pendingTasks, _summaryColors[2]),
      ('Completed Tasks', completedTasks, _summaryColors[3]),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            const Text(
              'StudyNest',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Divider(height: 28, color: Colors.black87),
            const Text(
              'Welcome, Student!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'You are studying ${regularSubjects.length} '
              '${regularSubjects.length == 1 ? 'subject' : 'subjects'}.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            for (var row = 0; row < 2; row++) ...[
              Row(
                children: [
                  Expanded(child: _summaryCard(summaries[row * 2])),
                  const SizedBox(width: 12),
                  Expanded(child: _summaryCard(summaries[row * 2 + 1])),
                ],
              ),
              if (row == 0) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _summaryCard((String, int, Color) summary) {
    final (label, count, color) = summary;
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black87, width: 1.2),
      ),
      child: Center(
        child: Text(
          '$label: $count',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
