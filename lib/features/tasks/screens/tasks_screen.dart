import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studynest/features/tasks/screens/task_form_screen.dart';
import 'package:studynest/utils/subject_lookup.dart';

import '../../../app/app_theme.dart';
import '../../../data/app_database.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_button.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  final AppDatabase database;
  final List<Subject> initialSubjects;
  final List<Task> initialTasks;
  final String? requestedSubjectId;
  final int subjectNavigationRequest;

  const TasksScreen({
    super.key,
    required this.database,
    required this.initialSubjects,
    required this.initialTasks,
    this.requestedSubjectId,
    this.subjectNavigationRequest = 0,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchController = TextEditingController();

  late List<Subject> _subjects = List.of(widget.initialSubjects);
  late List<Task> _tasks = List.of(widget.initialTasks);

  String _searchQuery = '';
  String? _selectedSubjectId;
  TaskUrgency? _selectedUrgency;
  bool? _selectedCompletionStatus;
  Timer? _urgencyTimer;

  List<Task> get _filteredTasks {
    final tasks = _tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      final matchesSubject =
          _selectedSubjectId == null || task.subjectId == _selectedSubjectId;

      final matchesUrgency =
          _selectedUrgency == null || task.urgency == _selectedUrgency;

      final matchesCompletion =
          _selectedCompletionStatus == null ||
          task.isCompleted == _selectedCompletionStatus;

      return matchesSearch &&
          matchesSubject &&
          matchesUrgency &&
          matchesCompletion;
    }).toList();

    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      return a.dueDate.compareTo(b.dueDate);
    });

    return tasks;
  }

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
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.initialSubjects, widget.initialSubjects)) {
      _subjects = List.of(widget.initialSubjects);
    }
    if (!identical(oldWidget.initialTasks, widget.initialTasks)) {
      _tasks = List.of(widget.initialTasks);
    }
    if (oldWidget.subjectNavigationRequest != widget.subjectNavigationRequest) {
      _selectedSubjectId = widget.requestedSubjectId;
    }
  }

  @override
  void dispose() {
    _urgencyTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks;

    return Scaffold(
      backgroundColor: AppTheme.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            TaskFilterButton(
              subjects: _subjects,
              selectedSubjectId: _selectedSubjectId,
              selectedUrgency: _selectedUrgency,
              selectedCompletionStatus: _selectedCompletionStatus,
              onApply: (selection) {
                setState(() {
                  _selectedSubjectId = selection.subjectId;
                  _selectedUrgency = selection.urgency;
                  _selectedCompletionStatus = selection.completionStatus;
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final subject = _getSubjectForTask(task);

                        if (subject == null) {
                          return const SizedBox.shrink();
                        }

                        return TaskCard(
                          task: task,
                          subject: subject,
                          onTap: () => _openTask(task),
                          onCompletionChanged: (isCompleted) async {
                            final updatedTask = task.copyWith(
                              isCompleted: isCompleted,
                            );
                            try {
                              await widget.database.saveTask(updatedTask);
                              if (!mounted) return;
                              _replaceTask(updatedTask);
                            } catch (_) {
                              _showStorageError();
                            }
                          },
                        );
                      },
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
        children: [
          const Expanded(
            child: Text(
              'Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add task',
            onPressed: _showAddTask,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        _searchQuery.isEmpty
            ? 'No tasks yet. Tap + to add one.'
            : 'No tasks found.',
        style: const TextStyle(color: AppTheme.mutedInk),
      ),
    );
  }

  Subject? _getSubjectForTask(Task task) {
    return findSubjectById(_subjects, task.subjectId);
  }

  Future<void> _showAddTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute<Task>(
        builder: (_) => TaskFormScreen(subjects: _subjects),
      ),
    );

    if (!mounted || task == null) return;

    try {
      await widget.database.saveTask(task);
      if (!mounted) return;
      setState(() => _tasks.add(task));
    } catch (_) {
      _showStorageError();
    }
  }

  void _openTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailsScreen(
          task: task,
          subjects: _subjects,
          onDelete: () async {
            await widget.database.deleteTask(task.id);
            if (!mounted) return;
            setState(() {
              _tasks.removeWhere((item) => item.id == task.id);
            });
          },
          onUpdate: (updatedTask) async {
            await widget.database.saveTask(updatedTask);
            if (!mounted) return;
            _replaceTask(updatedTask);
          },
        ),
      ),
    );
  }

  void _replaceTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == updatedTask.id);
      if (index != -1) _tasks[index] = updatedTask;
    });
  }

  void _showStorageError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not save the task. Try again.')),
    );
  }
}
