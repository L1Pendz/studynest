import 'package:flutter/material.dart';

import 'data/app_database.dart';
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
  late final Future<
    ({List<Subject> subjects, List<Task> tasks, List<StudyMaterial> materials})
  >
  _data = _database.loadOrSeedData();

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
                return const Scaffold(
                  body: Center(
                    child: Text('Could not load saved StudyNest data.'),
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      SubjectsScreen(
        database: widget.database,
        initialSubjects: _subjects,
        onSubjectsChanged: _reloadData,
      ),
      TasksScreen(
        database: widget.database,
        initialSubjects: _subjects,
        initialTasks: _tasks,
      ),
      ResourcesScreen(
        database: widget.database,
        subjects: _subjects,
        initialMaterials: _materials,
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
