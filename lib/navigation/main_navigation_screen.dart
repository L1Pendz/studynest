import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../features/home/screens/home_screen.dart';
import '../features/resources/models/study_material.dart';
import '../features/resources/screens/resources_screen.dart';
import '../features/subjects/screens/subjects_screen.dart';
import '../features/tasks/screens/task_details_screen.dart';
import '../features/tasks/screens/tasks_screen.dart';
import '../models/subject.dart';
import '../models/task.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppDatabase database;
  final List<Subject> subjects;
  final List<Task> tasks;
  final List<StudyMaterial> materials;

  const MainNavigationScreen({
    super.key,
    required this.database,
    required this.subjects,
    required this.tasks,
    required this.materials,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  int _taskSubjectNavigationRequest = 0;
  int _resourceSubjectNavigationRequest = 0;
  String? _requestedTaskSubjectId;
  String? _requestedResourceSubjectId;
  bool _requestedVideoSearch = false;
  late List<Subject> _subjects;
  late List<Task> _tasks;
  late List<StudyMaterial> _materials;

  @override
  void initState() {
    super.initState();
    _subjects = List.of(widget.subjects);
    _tasks = List.of(widget.tasks);
    _materials = List.of(widget.materials);
  }

  Future<void> _reloadData() async {
    try {
      final data = await widget.database.loadOrSeedData();
      if (!mounted) return;
      setState(() {
        _subjects = data.subjects;
        _tasks = data.tasks;
        _materials = data.materials;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not refresh saved data.')),
      );
    }
  }

  void _openSubjectTasks(String subjectId) {
    setState(() {
      _requestedTaskSubjectId = subjectId;
      _taskSubjectNavigationRequest++;
      _selectedIndex = 2;
    });
    Navigator.of(context).pop();
  }

  void _openSubjectResources(String subjectId, {required bool findVideos}) {
    setState(() {
      _requestedResourceSubjectId = subjectId;
      _requestedVideoSearch = findVideos;
      _resourceSubjectNavigationRequest++;
      _selectedIndex = 3;
    });
    Navigator.of(context).pop();
  }

  Future<void> _updateTask(Task updatedTask) async {
    await widget.database.saveTask(updatedTask);
    if (!mounted) return;
    setState(() {
      _tasks = _tasks
          .map((task) => task.id == updatedTask.id ? updatedTask : task)
          .toList();
    });
  }

  void _openTaskDetails(Task task) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TaskDetailsScreen(
          task: task,
          subjects: _subjects,
          onDelete: () async {
            await widget.database.deleteTask(task.id);
            if (!mounted) return;
            setState(() {
              _tasks = _tasks.where((item) => item.id != task.id).toList();
            });
          },
          onUpdate: _updateTask,
        ),
      ),
    );
  }

  Future<void> _updateTaskCompletion(Task task, bool isCompleted) async {
    try {
      await _updateTask(task.copyWith(isCompleted: isCompleted));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update the task. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        subjects: _subjects,
        tasks: _tasks,
        onTaskTap: _openTaskDetails,
        onCompletionChanged: _updateTaskCompletion,
      ),
      SubjectsScreen(
        database: widget.database,
        initialSubjects: _subjects,
        onSubjectsChanged: _reloadData,
        pendingTaskCounts: {
          for (final subject in _subjects)
            subject.id: _tasks
                .where(
                  (task) => task.subjectId == subject.id && !task.isCompleted,
                )
                .length,
        },
        onViewTasks: _openSubjectTasks,
        onViewResources: (subjectId) =>
            _openSubjectResources(subjectId, findVideos: false),
        onFindVideos: (subjectId) =>
            _openSubjectResources(subjectId, findVideos: true),
      ),
      TasksScreen(
        database: widget.database,
        initialSubjects: _subjects,
        initialTasks: _tasks,
        requestedSubjectId: _requestedTaskSubjectId,
        subjectNavigationRequest: _taskSubjectNavigationRequest,
      ),
      ResourcesScreen(
        database: widget.database,
        subjects: _subjects,
        initialMaterials: _materials,
        requestedSubjectId: _requestedResourceSubjectId,
        subjectNavigationRequest: _resourceSubjectNavigationRequest,
        requestedVideoSearch: _requestedVideoSearch,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Subjects',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Resources',
          ),
        ],
      ),
    );
  }
}
