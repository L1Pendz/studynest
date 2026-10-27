import 'package:flutter/material.dart';

import 'app/saved_data_error_screen.dart';
import 'app/app_theme.dart';
import 'data/app_database.dart';
import 'features/resources/data/material_file_storage.dart';
import 'features/resources/models/study_material.dart';
import 'models/subject.dart';
import 'models/task.dart';
import 'navigation/main_navigation_screen.dart';

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
      theme: AppTheme.light,
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
                return SavedDataErrorScreen(
                  error: snapshot.error,
                  onRetry: _retryLoading,
                  onResetSection: (section) => _confirmAndReset(
                    context,
                    resetAll: false,
                    section: section,
                  ),
                  onResetAll: () => _confirmAndReset(context, resetAll: true),
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
