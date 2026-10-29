import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:studynest/app/saved_data_error_screen.dart';
import 'package:studynest/data/app_database.dart';
import 'package:studynest/features/resources/models/study_material.dart';
import 'package:studynest/features/resources/services/youtube_video_search_service.dart';
import 'package:studynest/features/resources/screens/resource_form_screen.dart';
import 'package:studynest/features/subjects/subject_name_validator.dart';
import 'package:studynest/features/tasks/screens/task_form_screen.dart';
import 'package:studynest/models/subject.dart';
import 'package:studynest/models/task.dart';
import 'package:studynest/navigation/main_navigation_screen.dart';
import 'package:studynest/utils/subject_lookup.dart';
import 'package:studynest/utils/subject_ordering.dart';

void useTallTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  // These tests use separate in-memory databases, each with its own executor.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('main navigation opens every primary app section', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final data = await database.loadOrSeedData();

    await tester.pumpWidget(
      MaterialApp(
        home: MainNavigationScreen(
          database: database,
          subjects: data.subjects,
          tasks: data.tasks,
          materials: data.materials,
        ),
      ),
    );

    expect(find.text('Good to see you'), findsOneWidget);

    await tester.tap(find.text('Subjects').last);
    await tester.pumpAndSettle();
    expect(find.text('My Subjects'), findsOneWidget);
    expect(find.text('Database Systems'), findsOneWidget);

    await tester.tap(find.text('Tasks').last);
    await tester.pumpAndSettle();
    expect(find.text('My Tasks'), findsOneWidget);

    await tester.tap(find.text('Resources').last);
    await tester.pumpAndSettle();
    expect(find.text('Study Resources'), findsOneWidget);
    expect(find.text('My Materials'), findsOneWidget);
  });

  testWidgets('saved-data error screen exposes retry and targeted reset', (tester) async {
    var retries = 0;
    SavedDataSection? resetSection;
    var resetAllCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SavedDataErrorScreen(
          error: const SavedDataLoadException(
            SavedDataSection.tasks,
            'test failure',
          ),
          onRetry: () => retries++,
          onResetSection: (section) => resetSection = section,
          onResetAll: () => resetAllCalls++,
        ),
      ),
    );

    expect(find.text('Could not load saved tasks.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Reset Tasks'));
    await tester.tap(find.text('Reset Local Data'));

    expect(retries, 1);
    expect(resetSection, SavedDataSection.tasks);
    expect(resetAllCalls, 1);
  });

  testWidgets('resource link form validates and returns the entered material', (tester) async {
    useTallTestViewport(tester);
    const subject = Subject(id: 'biology', name: 'Biology');
    StudyMaterial? savedMaterial;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                savedMaterial = await Navigator.push<StudyMaterial>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ResourceFormScreen(subjects: [subject]),
                  ),
                );
              },
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open form'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resource link'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Material'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid web link.'), findsOneWidget);
    expect(find.text('Please enter a material name.'), findsOneWidget);
    expect(find.text('Please select a subject.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'https://example.com/biology');
    await tester.enterText(find.byType(TextFormField).at(1), 'Cell notes');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Biology').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Material'));
    await tester.pumpAndSettle();

    expect(savedMaterial, isNotNull);
    expect(savedMaterial!.title, 'Cell notes');
    expect(savedMaterial!.subjectId, subject.id);
    expect(savedMaterial!.type, StudyMaterialType.link);
    expect(savedMaterial!.resourceLocation, 'https://example.com/biology');
  });

  testWidgets('task edit form returns updated task details', (tester) async {
    useTallTestViewport(tester);
    const subject = Subject(id: 'biology', name: 'Biology');
    final original = Task(
      id: 'task-1',
      title: 'Read chapter',
      subjectId: subject.id,
      description: 'Chapter 1',
      dueDate: DateTime(2030, 1, 10),
    );
    Task? savedTask;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                savedTask = await Navigator.push<Task>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskFormScreen(
                      task: original,
                      subjects: const [subject],
                    ),
                  ),
                );
              },
              child: const Text('Open task form'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open task form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Read chapter two');
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(savedTask, isNotNull);
    expect(savedTask!.id, original.id);
    expect(savedTask!.title, 'Read chapter two');
    expect(savedTask!.subjectId, original.subjectId);
    expect(savedTask!.description, original.description);
  });

  group('AppDatabase', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('seeds starter subjects and tasks on first load', () async {
      final data = await database.loadOrSeedData();

      expect(data.subjects.map((subject) => subject.name), contains('Database Systems'));
      expect(data.tasks, isNotEmpty);
      expect(data.materials, isEmpty);
    });

    test('subject, task, and material changes persist and cascade safely', () async {
      final subject = Subject(id: 'custom', name: 'Biology');
      await database.saveSubject(subject);
      final task = Task(
        id: 'custom-task',
        title: 'Review cells',
        subjectId: subject.id,
        dueDate: DateTime(2030),
      );
      final material = StudyMaterial(
        id: 'custom-material',
        title: 'Cell notes',
        subjectId: subject.id,
        type: StudyMaterialType.link,
        resourceLocation: 'https://example.com/cells',
        addedAt: DateTime(2030),
      );
      await database.saveTask(task);
      await database.saveMaterial(material);

      var data = await database.loadOrSeedData();
      expect(data.subjects.any((item) => item.id == subject.id), isTrue);
      expect(data.tasks.singleWhere((item) => item.id == task.id).title, task.title);
      expect(data.materials.singleWhere((item) => item.id == material.id).resourceLocation,
          material.resourceLocation);

      await database.deleteSubject(subject.id);
      data = await database.loadOrSeedData();
      expect(data.subjects.any((item) => item.id == subject.id), isFalse);
      expect(data.tasks.singleWhere((item) => item.id == task.id).subjectId,
          Subject.noSubjectId);
      expect(data.materials.singleWhere((item) => item.id == material.id).subjectId,
          Subject.noSubjectId);

      await database.deleteTask(task.id);
      await database.deleteMaterial(material.id);
      data = await database.loadOrSeedData();
      expect(data.tasks.any((item) => item.id == task.id), isFalse);
      expect(data.materials.any((item) => item.id == material.id), isFalse);
    });

    test('updates tasks and supports section and full resets', () async {
      final data = await database.loadOrSeedData();
      final task = data.tasks.first;
      await database.saveTask(task.copyWith(isCompleted: !task.isCompleted));
      expect(
        (await database.loadOrSeedData()).tasks
            .singleWhere((item) => item.id == task.id)
            .isCompleted,
        !task.isCompleted,
      );

      await database.resetTasks();
      expect((await database.loadOrSeedData()).tasks, hasLength(12));

      await database.saveMaterial(
        StudyMaterial(
          id: 'reset-material',
          title: 'Temporary link',
          subjectId: Subject.noSubjectId,
          type: StudyMaterialType.link,
          resourceLocation: 'https://example.com',
          addedAt: DateTime(2030),
        ),
      );
      await database.resetMaterials();
      expect((await database.loadOrSeedData()).materials, isEmpty);

      await database.resetLocalData();
      final reset = await database.loadOrSeedData();
      expect(reset.subjects.map((item) => item.name), contains('Database Systems'));
      expect(reset.tasks, hasLength(12));
      expect(reset.materials, isEmpty);
    });
  });

  group('subject helpers', () {
    const regular = Subject(id: '1', name: 'Math');
    const noSubject = Subject(
      id: Subject.noSubjectId,
      name: Subject.noSubjectName,
    );

    test('validates names, detects duplicates case-insensitively, and permits edits', () {
      expect(
        validateSubjectName(null, const [regular], duplicateMessage: 'Duplicate'),
        'Please enter a subject name.',
      );
      expect(
        validateSubjectName(' math ', const [regular], duplicateMessage: 'Duplicate'),
        'Duplicate',
      );
      expect(
        validateSubjectName('Math', const [regular], excludedSubjectId: '1',
            duplicateMessage: 'Duplicate'),
        isNull,
      );
    });

    test('finds subjects and keeps No Subject first in pickers', () {
      expect(findSubjectById(const [regular], '1'), regular);
      expect(findSubjectById(const [regular], 'missing'), isNull);
      expect(orderSubjectsForPicker(const [regular, noSubject]).first, noSubject);
    });
  });

  test('YouTube service reports when search has not been configured', () async {
    final client = MockClient((_) async => http.Response('{}', 200));
    addTearDown(client.close);
    final service = YouTubeVideoSearchService(client: client);
    expect(service.isConfigured, isFalse);
    await expectLater(
      service.search('biology'),
      throwsA(isA<YouTubeVideoSearchException>()),
    );
  });
}
