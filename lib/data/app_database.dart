import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../features/resources/models/study_material.dart';
import '../models/subject.dart' as model;
import '../models/task.dart' as model;

part 'app_database.g.dart';

enum SavedDataSection { subjects, tasks, materials }

class SavedDataLoadException implements Exception {
  final SavedDataSection section;
  final Object cause;

  const SavedDataLoadException(this.section, this.cause);

  @override
  String toString() => 'Could not load saved $section data: $cause';
}

class SubjectsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TasksTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subjectId => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get mediumThresholdMicros => integer()();
  IntColumn get highThresholdMicros => integer()();
  IntColumn get criticalThresholdMicros => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudyMaterialsTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get subjectId => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get type => textEnum<StudyMaterialType>()();
  TextColumn get resourceLocation => text()();
  TextColumn get fileName => text().nullable()();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [SubjectsTable, TasksTable, StudyMaterialsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? queryExecutor])
    : super(queryExecutor ?? driftDatabase(name: 'studynest'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await batch((batch) {
        batch.insertAll(subjectsTable, _starterSubjects);
        batch.insertAll(tasksTable, _starterTasks);
      });
    },
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        await migrator.createTable(studyMaterialsTable);
      }
      if (from < 3) {
        await into(subjectsTable).insertOnConflictUpdate(
          SubjectsTableCompanion.insert(
            id: model.Subject.noSubjectId,
            name: model.Subject.noSubjectName,
            description: const Value(
              'Tasks and materials without an assigned subject.',
            ),
          ),
        );
      }
      if (from < 4) {
        final subjectIds = (await select(
          subjectsTable,
        ).get()).map((subject) => subject.id).toList();

        await (update(
          tasksTable,
        )..where((task) => task.subjectId.isNotIn(subjectIds))).write(
          TasksTableCompanion(subjectId: Value(model.Subject.noSubjectId)),
        );
        await (update(
          studyMaterialsTable,
        )..where((material) => material.subjectId.isNotIn(subjectIds))).write(
          StudyMaterialsTableCompanion(
            subjectId: Value(model.Subject.noSubjectId),
          ),
        );
      }
    },
  );

  Future<
    ({
      List<model.Subject> subjects,
      List<model.Task> tasks,
      List<StudyMaterial> materials,
    })
  >
  loadOrSeedData() async {
    final subjects = await _loadSection(SavedDataSection.subjects, () async {
      final rows = await select(subjectsTable).get();
      return rows
          .map(
            (row) => model.Subject(
              id: row.id,
              name: row.name,
              description: row.description,
            ),
          )
          .toList();
    });
    final tasks = await _loadSection(SavedDataSection.tasks, () async {
      final rows = await select(tasksTable).get();
      return rows
          .map(
            (row) => model.Task(
              id: row.id,
              title: row.title,
              subjectId: row.subjectId,
              description: row.description,
              dueDate: row.dueDate,
              mediumThreshold: Duration(
                microseconds: row.mediumThresholdMicros,
              ),
              highThreshold: Duration(microseconds: row.highThresholdMicros),
              criticalThreshold: Duration(
                microseconds: row.criticalThresholdMicros,
              ),
              isCompleted: row.isCompleted,
            ),
          )
          .toList();
    });
    final materials = await _loadSection(SavedDataSection.materials, () async {
      final rows = await select(studyMaterialsTable).get();
      return rows
          .map(
            (row) => StudyMaterial(
              id: row.id,
              title: row.title,
              subjectId: row.subjectId,
              description: row.description,
              type: row.type,
              resourceLocation: row.resourceLocation,
              fileName: row.fileName,
              addedAt: row.addedAt,
            ),
          )
          .toList();
    });

    return (subjects: subjects, tasks: tasks, materials: materials);
  }

  Future<T> _loadSection<T>(
    SavedDataSection section,
    Future<T> Function() load,
  ) async {
    try {
      return await load();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SavedDataLoadException(section, error),
        stackTrace,
      );
    }
  }

  Future<void> resetSubjects() async {
    final starterSubjectIds = _starterSubjects
        .map((subject) => subject.id.value)
        .toList();

    await transaction(() async {
      await (update(
        tasksTable,
      )..where((task) => task.subjectId.isNotIn(starterSubjectIds))).write(
        TasksTableCompanion(subjectId: Value(model.Subject.noSubjectId)),
      );
      await (update(
            studyMaterialsTable,
          )..where((material) => material.subjectId.isNotIn(starterSubjectIds)))
          .write(
            StudyMaterialsTableCompanion(
              subjectId: Value(model.Subject.noSubjectId),
            ),
          );
      await delete(subjectsTable).go();
      await batch((batch) {
        batch.insertAll(subjectsTable, _starterSubjects);
      });
    });
  }

  Future<void> resetTasks() async {
    await transaction(() async {
      final subjectIds = (await select(
        subjectsTable,
      ).get()).map((subject) => subject.id).toSet();
      final starterTasks = _starterTasks.map((task) {
        if (subjectIds.contains(task.subjectId.value)) return task;
        return task.copyWith(subjectId: Value(model.Subject.noSubjectId));
      }).toList();

      await delete(tasksTable).go();
      await batch((batch) {
        batch.insertAll(tasksTable, starterTasks);
      });
    });
  }

  Future<void> resetMaterials() async {
    await transaction(() async {
      await delete(studyMaterialsTable).go();
    });
  }

  Future<void> resetLocalData() async {
    await transaction(() async {
      await delete(studyMaterialsTable).go();
      await delete(tasksTable).go();
      await delete(subjectsTable).go();

      await batch((batch) {
        batch.insertAll(subjectsTable, _starterSubjects);
        batch.insertAll(tasksTable, _starterTasks);
      });
    });
  }

  Future<void> saveSubject(model.Subject subject) {
    return into(subjectsTable).insertOnConflictUpdate(
      SubjectsTableCompanion.insert(
        id: subject.id,
        name: subject.name,
        description: Value(subject.description),
      ),
    );
  }

  Future<void> deleteSubject(String id) async {
    if (id == model.Subject.noSubjectId) {
      throw StateError('The No Subject category cannot be deleted.');
    }

    await transaction(() async {
      await (update(
        tasksTable,
      )..where((task) => task.subjectId.equals(id))).write(
        TasksTableCompanion(subjectId: Value(model.Subject.noSubjectId)),
      );
      await (update(
        studyMaterialsTable,
      )..where((material) => material.subjectId.equals(id))).write(
        StudyMaterialsTableCompanion(
          subjectId: Value(model.Subject.noSubjectId),
        ),
      );
      await (delete(
        subjectsTable,
      )..where((subject) => subject.id.equals(id))).go();
    });
  }

  Future<void> saveTask(model.Task task) {
    return into(tasksTable).insertOnConflictUpdate(
      TasksTableCompanion.insert(
        id: task.id,
        title: task.title,
        subjectId: task.subjectId,
        description: Value(task.description),
        dueDate: task.dueDate,
        mediumThresholdMicros: task.mediumThreshold.inMicroseconds,
        highThresholdMicros: task.highThreshold.inMicroseconds,
        criticalThresholdMicros: task.criticalThreshold.inMicroseconds,
        isCompleted: Value(task.isCompleted),
      ),
    );
  }

  Future<void> deleteTask(String id) {
    return (delete(tasksTable)..where((task) => task.id.equals(id))).go();
  }

  Future<void> saveMaterial(StudyMaterial material) {
    return into(studyMaterialsTable).insertOnConflictUpdate(
      StudyMaterialsTableCompanion.insert(
        id: material.id,
        title: material.title,
        subjectId: material.subjectId,
        description: Value(material.description),
        type: material.type,
        resourceLocation: material.resourceLocation,
        fileName: Value(material.fileName),
        addedAt: material.addedAt,
      ),
    );
  }

  Future<void> deleteMaterial(String id) {
    return (delete(
      studyMaterialsTable,
    )..where((material) => material.id.equals(id))).go();
  }

  List<SubjectsTableCompanion> get _starterSubjects => [
    SubjectsTableCompanion.insert(
      id: model.Subject.noSubjectId,
      name: model.Subject.noSubjectName,
      description: const Value(
        'Tasks and materials without an assigned subject.',
      ),
    ),
    SubjectsTableCompanion.insert(
      id: '1',
      name: 'Database Systems',
      description: Value('Study of database design, SQL, and data management.'),
    ),
    SubjectsTableCompanion.insert(
      id: '2',
      name: 'Software Engineering',
      description: Value(
        'Study of software development processes and methodologies.',
      ),
    ),
    SubjectsTableCompanion.insert(
      id: '3',
      name: 'Web Development',
      description: Value(
        'Study of web application development using HTML, CSS, and JavaScript.',
      ),
    ),
  ];

  List<TasksTableCompanion> get _starterTasks {
    final now = DateTime.now();
    return [
      _starterTask(
        '1',
        'Finish Database Assignment',
        '1',
        'Complete the SQL exercises.',
        now.add(const Duration(days: 5)),
      ),
      _starterTask(
        '2',
        'Study Software Engineering',
        '2',
        'Review software development methodologies.',
        now.add(const Duration(days: 2)),
      ),
      _starterTask(
        '3',
        'Build Login Page',
        '3',
        'Create the login page using HTML, CSS, and JavaScript.',
        now.add(const Duration(days: 10)),
      ),
      _starterTask(
        '4',
        'Prepare SQL Queries',
        '1',
        'Practice SELECT, JOIN, GROUP BY, and subqueries.',
        now.add(const Duration(days: 1)),
      ),
      _starterTask(
        '5',
        'Software Design Documentation',
        '2',
        'Complete the system design documentation.',
        now.add(const Duration(days: 3)),
      ),
      _starterTask(
        '6',
        'Create Portfolio Layout',
        '3',
        'Design the main layout for the personal portfolio website.',
        now.add(const Duration(days: 7)),
      ),
      _starterTask(
        '7',
        'Database Normalization Exercises',
        '1',
        'Complete exercises on 1NF, 2NF, and 3NF.',
        now.add(const Duration(days: 14)),
      ),
      _starterTask(
        '8',
        'Write Unit Tests',
        '2',
        'Add unit tests for the main application services.',
        now.add(const Duration(hours: 18)),
      ),
      _starterTask(
        '9',
        'Fix Responsive Design',
        '3',
        'Make the website layout responsive on mobile devices.',
        now.subtract(const Duration(days: 1)),
      ),
      _starterTask(
        '10',
        'Review Database Lecture',
        '1',
        'Review the lecture notes before the upcoming quiz.',
        now.add(const Duration(days: 20)),
        isCompleted: true,
      ),
      _starterTask(
        '11',
        'Agile Methodology Report',
        '2',
        'Write a short report about Agile development practices.',
        now.add(const Duration(days: 4)),
        isCompleted: true,
      ),
      _starterTask(
        '12',
        'JavaScript Form Validation',
        '3',
        'Add client-side validation to the registration form.',
        now.add(const Duration(days: 6)),
      ),
    ];
  }

  TasksTableCompanion _starterTask(
    String id,
    String title,
    String subjectId,
    String description,
    DateTime dueDate, {
    bool isCompleted = false,
  }) {
    return TasksTableCompanion.insert(
      id: id,
      title: title,
      subjectId: subjectId,
      description: Value(description),
      dueDate: dueDate,
      mediumThresholdMicros: const Duration(days: 7).inMicroseconds,
      highThresholdMicros: const Duration(days: 3).inMicroseconds,
      criticalThresholdMicros: const Duration(days: 1).inMicroseconds,
      isCompleted: Value(isCompleted),
    );
  }
}
