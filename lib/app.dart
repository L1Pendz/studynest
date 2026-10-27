import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'data/material_file_storage.dart';
import 'models/study_material.dart';
import 'models/subject.dart';
import 'models/task.dart';
import 'screens/home/home_screen.dart';
import 'screens/subjects/subjects_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/resources/resources_screen.dart';

class StudyNestApp extends StatefulWidget {
  const StudyNestApp({super.key});

  @override
  State<StudyNestApp> createState() => _StudyNestAppState();
}

class _StudyNestAppState extends State<StudyNestApp> {
  late final AppDatabase _database = AppDatabase();
  late Future<
    ({List<Subject> subjects, List<Task> tasks, List<StudyMaterial> materials})
  >
  _data = _database.loadOrSeedData();

  void _retryLoading() {
    setState(() {
      _data = _database.loadOrSeedData();
    });
  }

  Future<void> _confirmAndReset(
    BuildContext context, {
    required bool resetAll,
    SavedDataSection? section,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          resetAll
              ? 'Reset All Local Data?'
              : section == SavedDataSection.subjects
              ? 'Reset Subjects?'
              : section == SavedDataSection.tasks
              ? 'Reset Tasks?'
              : 'Reset Materials?',
        ),
        content: Text(
          resetAll
              ? 'This will remove saved subjects, tasks, and study materials, '
                    'then restore the starter subjects and tasks. This cannot be undone.'
              : section == SavedDataSection.subjects
              ? 'This will restore the starter subjects. Tasks and materials '
                    'will be kept; items assigned to removed subjects will move to No Subject.'
              : section == SavedDataSection.tasks
              ? 'This will remove all saved tasks. Subjects and materials '
                    'will remain unchanged.'
              : 'This will remove all saved study materials. Subjects and '
                    'tasks will remain unchanged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (!mounted || !context.mounted || confirmed != true) return;

    try {
      if (resetAll) {
        await _clearStoredMaterialsSafely();
        await _database.resetLocalData();
      } else if (section == SavedDataSection.subjects) {
        await _database.resetSubjects();
      } else if (section == SavedDataSection.tasks) {
        await _database.resetTasks();
      } else if (section == SavedDataSection.materials) {
        await _clearStoredMaterialsSafely();
        await _database.resetMaterials();
      } else {
        throw StateError('A data section is required for a targeted reset.');
      }
      if (!mounted) return;
      _retryLoading();
    } catch (error, stackTrace) {
      debugPrint('Could not reset local data: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not reset local data.')),
      );
    }
  }

  Future<void> _clearStoredMaterialsSafely() async {
    try {
      await clearStoredMaterials();
    } catch (error, stackTrace) {
      debugPrint('Could not clear stored material files: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home:
          FutureBuilder<
            ({
              List<Subject> subjects,
              List<Task> tasks,
              List<StudyMaterial> materials,
            })
          >(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                final error = snapshot.error;
                final failedSection = error is SavedDataLoadException
                    ? error.section
                    : null;
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            failedSection == null
                                ? 'Could not load saved StudyNest data.'
                                : 'Could not load saved ${failedSection.name}.',
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: _retryLoading,
                                child: const Text('Retry'),
                              ),
                              if (failedSection != null)
                                FilledButton(
                                  onPressed: () => _confirmAndReset(
                                    context,
                                    resetAll: false,
                                    section: failedSection,
                                  ),
                                  child: Text(switch (failedSection) {
                                    SavedDataSection.subjects =>
                                      'Reset Subjects',
                                    SavedDataSection.tasks => 'Reset Tasks',
                                    SavedDataSection.materials =>
                                      'Reset Materials',
                                  }),
                                ),
                              FilledButton(
                                onPressed: () =>
                                    _confirmAndReset(context, resetAll: true),
                                child: Text(
                                  failedSection == SavedDataSection.materials
                                      ? 'Reset All Local Data'
                                      : 'Reset Local Data',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return MainNavigationScreen(
                database: _database,
                subjects: snapshot.data!.subjects,
                tasks: snapshot.data!.tasks,
                materials: snapshot.data!.materials,
              );
            },
          ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
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
