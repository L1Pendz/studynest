import 'package:flutter/material.dart';
import 'package:studynest/screens/tasks/task_form_screen.dart';

import '../../models/subject.dart';
import '../../models/task.dart';
import '../../widgets/tasks/task_card.dart';
import '../../widgets/tasks/task_filter_button.dart';
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
    Task(
      id: '3',
      title: 'Build Login Page',
      subjectId: '3',
      description: 'Create the login page using HTML, CSS, and JavaScript.',
      dueDate: DateTime.now().add(const Duration(days: 10)),
    ),
    Task(
      id: '4',
      title: 'Prepare SQL Queries',
      subjectId: '1',
      description: 'Practice SELECT, JOIN, GROUP BY, and subqueries.',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      id: '5',
      title: 'Software Design Documentation',
      subjectId: '2',
      description: 'Complete the system design documentation.',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      id: '6',
      title: 'Create Portfolio Layout',
      subjectId: '3',
      description: 'Design the main layout for the personal portfolio website.',
      dueDate: DateTime.now().add(const Duration(days: 7)),
    ),
    Task(
      id: '7',
      title: 'Database Normalization Exercises',
      subjectId: '1',
      description: 'Complete exercises on 1NF, 2NF, and 3NF.',
      dueDate: DateTime.now().add(const Duration(days: 14)),
    ),
    Task(
      id: '8',
      title: 'Write Unit Tests',
      subjectId: '2',
      description: 'Add unit tests for the main application services.',
      dueDate: DateTime.now().add(const Duration(hours: 18)),
    ),
    Task(
      id: '9',
      title: 'Fix Responsive Design',
      subjectId: '3',
      description: 'Make the website layout responsive on mobile devices.',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '10',
      title: 'Review Database Lecture',
      subjectId: '1',
      description: 'Review the lecture notes before the upcoming quiz.',
      dueDate: DateTime.now().add(const Duration(days: 20)),
      isCompleted: true,
    ),
    Task(
      id: '11',
      title: 'Agile Methodology Report',
      subjectId: '2',
      description: 'Write a short report about Agile development practices.',
      dueDate: DateTime.now().add(const Duration(days: 4)),
      isCompleted: true,
    ),
    Task(
      id: '12',
      title: 'JavaScript Form Validation',
      subjectId: '3',
      description: 'Add client-side validation to the registration form.',
      dueDate: DateTime.now().add(const Duration(days: 6)),
    ),
  ];

  String _searchQuery = '';
  String? _selectedSubjectId;
  TaskUrgency? _selectedUrgency;
  bool? _selectedCompletionStatus;

  List<Task> get _filteredTasks {
    return _tasks.where((task) {
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
