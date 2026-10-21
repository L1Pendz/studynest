import 'package:flutter/material.dart';
import 'package:studynest/screens/tasks/task_form_screen.dart';

import '../../models/subject.dart';
import '../../models/task.dart';
import '../../widgets/tasks/task_card.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchController = TextEditingController();

  final List<Subject> _subjects = [
    Subject(
      id: '1',
      name: 'Database Systems',
      description: 'Study of database design, SQL, and data management.',
    ),
    Subject(
      id: '2',
      name: 'Software Engineering',
      description: 'Study of software development processes and methodologies.',
    ),
    Subject(
      id: '3',
      name: 'Web Development',
      description:
          'Study of web application development using HTML, CSS, and JavaScript.',
    ),
  ];

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Finish Database Assignment',
      subjectId: '1',
      description: 'Complete the SQL exercises.',
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    Task(
      id: '2',
      title: 'Study Software Engineering',
      subjectId: '2',
      description: 'Review software development methodologies.',
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  String _searchQuery = '';

  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Colors.black87),
            _buildSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'My Tasks',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          onCompletionChanged: (isCompleted) {
                            setState(() {
                              final index = _tasks.indexWhere(
                                (item) => item.id == task.id,
                              );

                              if (index != -1) {
                                _tasks[index] = task.copyWith(
                                  isCompleted: isCompleted,
                                );
                              }
                            });
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
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Add task',
            onPressed: _showAddTask,
            icon: const Icon(Icons.add, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black87, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  Subject? _getSubjectForTask(Task task) {
    for (final subject in _subjects) {
      if (subject.id == task.subjectId) {
        return subject;
      }
    }

    return null;
  }

  Future<void> _showAddTask() async {
    final task = await Navigator.push<Task>(
      context,
      MaterialPageRoute<Task>(
        builder: (_) => TaskFormScreen(subjects: _subjects),
      ),
    );

    if (!mounted || task == null) return;

    setState(() {
      _tasks.add(task);
    });
  }

  void _openTask(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailsScreen(
          task: task,
          subjects: _subjects,
          onDelete: () {
            setState(() {
              _tasks.removeWhere((item) => item.id == task.id);
            });
          },
          onUpdate: (updatedTask) {
            setState(() {
              final index = _tasks.indexWhere(
                (item) => item.id == updatedTask.id,
              );

              if (index != -1) {
                _tasks[index] = updatedTask;
              }
            });
          },
        ),
      ),
    );
  }
}
