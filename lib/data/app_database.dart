import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/subject.dart' as model;
import '../models/task.dart' as model;

part 'app_database.g.dart';

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

@DriftDatabase(tables: [SubjectsTable, TasksTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? queryExecutor])
    : super(queryExecutor ?? driftDatabase(name: 'studynest'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
      await batch((batch) {
        batch.insertAll(subjectsTable, _starterSubjects);
        batch.insertAll(tasksTable, _starterTasks);
      });
    },
  );

  Future<({List<model.Subject> subjects, List<model.Task> tasks})>
  loadOrSeedData() async {
    final subjectRows = await select(subjectsTable).get();
    final taskRows = await select(tasksTable).get();

    return (
      subjects: subjectRows
          .map(
            (row) => model.Subject(
              id: row.id,
              name: row.name,
              description: row.description,
            ),
          )
          .toList(),
      tasks: taskRows
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
          .toList(),
    );
  }

  List<SubjectsTableCompanion> get _starterSubjects => [
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
