import 'package:flutter/material.dart';

import 'data/app_database.dart';
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
  late final Future<({List<Subject> subjects, List<Task> tasks})> _data =
      _database.loadOrSeedData();

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
      home: FutureBuilder<({List<Subject> subjects, List<Task> tasks})>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Could not load saved StudyNest data.')),
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

  const MainNavigationScreen({
    super.key,
    required this.database,
    required this.subjects,
    required this.tasks,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    SubjectsScreen(database: widget.database, initialSubjects: widget.subjects),
    TasksScreen(
      database: widget.database,
      initialSubjects: widget.subjects,
      initialTasks: widget.tasks,
    ),
    const ResourcesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
