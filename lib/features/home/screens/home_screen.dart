import 'package:flutter/material.dart';
import 'package:studynest/utils/subject_lookup.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../../tasks/widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Subject> subjects;
  final List<Task> tasks;
  final ValueChanged<Task> onTaskTap;
  final Future<void> Function(Task, bool) onCompletionChanged;

  const HomeScreen({
    super.key,
    required this.subjects,
    required this.tasks,
    required this.onTaskTap,
    required this.onCompletionChanged,
  });

  static const _summaryStyles = [
    (Icons.checklist_rounded, Color(0xFFE8F0FE), Color(0xFF315C9B)),
    (Icons.today_rounded, Color(0xFFFFF2DF), Color(0xFF9A5B00)),
    (Icons.pending_actions_rounded, Color(0xFFEAF5F1), Color(0xFF24745A)),
    (Icons.task_alt_rounded, Color(0xFFF0ECFA), Color(0xFF6346A5)),
  ];

  @override
  Widget build(BuildContext context) {
    final regularSubjects = subjects.where((subject) => !subject.isNoSubject);
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;
    final now = DateTime.now();
    final dueToday = tasks.where((task) {
      if (task.isCompleted) return false;
      return task.dueDate.year == now.year &&
          task.dueDate.month == now.month &&
          task.dueDate.day == now.day;
    }).length;

    final summaries = [
      ('Total Tasks', tasks.length),
      ('Due Today', dueToday),
      ('Pending Tasks', pendingTasks),
      ('Completed Tasks', completedTasks),
    ];
    final upcomingTasks = tasks.where((task) => !task.isCompleted).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final visibleUpcomingTasks = upcomingTasks.take(4).toList();

    return Scaffold(
      backgroundColor: AppTheme.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                children: [
                  const Text(
                    'Good to see you',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: AppTheme.ink),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You are studying ${regularSubjects.length} '
                    '${regularSubjects.length == 1 ? 'subject' : 'subjects'}.',
                    style: TextStyle(fontSize: 15, color: AppTheme.mutedInk),
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
                  const SizedBox(height: 28),
                  const Text(
                    'Coming up',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.ink),
                  ),
                  const SizedBox(height: 12),
                  if (visibleUpcomingTasks.isEmpty)
                    _buildEmptyTasksState()
                  else
                    for (final task in visibleUpcomingTasks)
                      TaskCard(
                        task: task,
                        subject:
                            findSubjectById(subjects, task.subjectId) ??
                            Subject(
                              id: task.subjectId,
                              name: 'Unknown subject',
                            ),
                        onTap: () => onTaskTap(task),
                        onCompletionChanged: (isCompleted) =>
                            onCompletionChanged(task, isCompleted),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'Home',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard((String, int) summary) {
    final (label, count) = summary;
    final index = summariesIndex(label);
    final (icon, tint, foreground) = _summaryStyles[index];
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.outline),
        boxShadow: const [
          BoxShadow(color: Color(0x080F172A), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: foreground),
          ),
          const SizedBox(height: 10),
          Text('$count', style: const TextStyle(fontSize: 25, height: 1, fontWeight: FontWeight.w700, color: AppTheme.ink)),
          const SizedBox(height: 5),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.mutedInk)),
        ],
      ),
    );
  }

  int summariesIndex(String label) => switch (label) {
    'Total Tasks' => 0,
    'Due Today' => 1,
    'Pending Tasks' => 2,
    _ => 3,
  };

  Widget _buildEmptyTasksState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Text(
        tasks.isEmpty
            ? 'No tasks yet. Add a task to see it here.'
            : 'No upcoming tasks. You have completed every task.',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.mutedInk, height: 1.4),
      ),
    );
  }
}
