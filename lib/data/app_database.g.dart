// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubjectsTableTable extends SubjectsTable
    with TableInfo<$SubjectsTableTable, SubjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $SubjectsTableTable createAlias(String alias) {
    return $SubjectsTableTable(attachedDatabase, alias);
  }
}

class SubjectsTableData extends DataClass
    implements Insertable<SubjectsTableData> {
  final String id;
  final String name;
  final String description;
  const SubjectsTableData({
    required this.id,
    required this.name,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  SubjectsTableCompanion toCompanion(bool nullToAbsent) {
    return SubjectsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
  }

  factory SubjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  SubjectsTableData copyWith({String? id, String? name, String? description}) =>
      SubjectsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  SubjectsTableData copyWithCompanion(SubjectsTableCompanion data) {
    return SubjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description);
}

class SubjectsTableCompanion extends UpdateCompanion<SubjectsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int> rowid;
  const SubjectsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<SubjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return SubjectsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediumThresholdMicrosMeta =
      const VerificationMeta('mediumThresholdMicros');
  @override
  late final GeneratedColumn<int> mediumThresholdMicros = GeneratedColumn<int>(
    'medium_threshold_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _highThresholdMicrosMeta =
      const VerificationMeta('highThresholdMicros');
  @override
  late final GeneratedColumn<int> highThresholdMicros = GeneratedColumn<int>(
    'high_threshold_micros',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _criticalThresholdMicrosMeta =
      const VerificationMeta('criticalThresholdMicros');
  @override
  late final GeneratedColumn<int> criticalThresholdMicros =
      GeneratedColumn<int>(
        'critical_threshold_micros',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subjectId,
    description,
    dueDate,
    mediumThresholdMicros,
    highThresholdMicros,
    criticalThresholdMicros,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('medium_threshold_micros')) {
      context.handle(
        _mediumThresholdMicrosMeta,
        mediumThresholdMicros.isAcceptableOrUnknown(
          data['medium_threshold_micros']!,
          _mediumThresholdMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mediumThresholdMicrosMeta);
    }
    if (data.containsKey('high_threshold_micros')) {
      context.handle(
        _highThresholdMicrosMeta,
        highThresholdMicros.isAcceptableOrUnknown(
          data['high_threshold_micros']!,
          _highThresholdMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_highThresholdMicrosMeta);
    }
    if (data.containsKey('critical_threshold_micros')) {
      context.handle(
        _criticalThresholdMicrosMeta,
        criticalThresholdMicros.isAcceptableOrUnknown(
          data['critical_threshold_micros']!,
          _criticalThresholdMicrosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_criticalThresholdMicrosMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      mediumThresholdMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medium_threshold_micros'],
      )!,
      highThresholdMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}high_threshold_micros'],
      )!,
      criticalThresholdMicros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}critical_threshold_micros'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String title;
  final String subjectId;
  final String description;
  final DateTime dueDate;
  final int mediumThresholdMicros;
  final int highThresholdMicros;
  final int criticalThresholdMicros;
  final bool isCompleted;
  const TasksTableData({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.description,
    required this.dueDate,
    required this.mediumThresholdMicros,
    required this.highThresholdMicros,
    required this.criticalThresholdMicros,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['subject_id'] = Variable<String>(subjectId);
    map['description'] = Variable<String>(description);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['medium_threshold_micros'] = Variable<int>(mediumThresholdMicros);
    map['high_threshold_micros'] = Variable<int>(highThresholdMicros);
    map['critical_threshold_micros'] = Variable<int>(criticalThresholdMicros);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      subjectId: Value(subjectId),
      description: Value(description),
      dueDate: Value(dueDate),
      mediumThresholdMicros: Value(mediumThresholdMicros),
      highThresholdMicros: Value(highThresholdMicros),
      criticalThresholdMicros: Value(criticalThresholdMicros),
      isCompleted: Value(isCompleted),
    );
  }

  factory TasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      mediumThresholdMicros: serializer.fromJson<int>(
        json['mediumThresholdMicros'],
      ),
      highThresholdMicros: serializer.fromJson<int>(
        json['highThresholdMicros'],
      ),
      criticalThresholdMicros: serializer.fromJson<int>(
        json['criticalThresholdMicros'],
      ),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subjectId': serializer.toJson<String>(subjectId),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'mediumThresholdMicros': serializer.toJson<int>(mediumThresholdMicros),
      'highThresholdMicros': serializer.toJson<int>(highThresholdMicros),
      'criticalThresholdMicros': serializer.toJson<int>(
        criticalThresholdMicros,
      ),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  TasksTableData copyWith({
    String? id,
    String? title,
    String? subjectId,
    String? description,
    DateTime? dueDate,
    int? mediumThresholdMicros,
    int? highThresholdMicros,
    int? criticalThresholdMicros,
    bool? isCompleted,
  }) => TasksTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    subjectId: subjectId ?? this.subjectId,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    mediumThresholdMicros: mediumThresholdMicros ?? this.mediumThresholdMicros,
    highThresholdMicros: highThresholdMicros ?? this.highThresholdMicros,
    criticalThresholdMicros:
        criticalThresholdMicros ?? this.criticalThresholdMicros,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      mediumThresholdMicros: data.mediumThresholdMicros.present
          ? data.mediumThresholdMicros.value
          : this.mediumThresholdMicros,
      highThresholdMicros: data.highThresholdMicros.present
          ? data.highThresholdMicros.value
          : this.highThresholdMicros,
      criticalThresholdMicros: data.criticalThresholdMicros.present
          ? data.criticalThresholdMicros.value
          : this.criticalThresholdMicros,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('mediumThresholdMicros: $mediumThresholdMicros, ')
          ..write('highThresholdMicros: $highThresholdMicros, ')
          ..write('criticalThresholdMicros: $criticalThresholdMicros, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subjectId,
    description,
    dueDate,
    mediumThresholdMicros,
    highThresholdMicros,
    criticalThresholdMicros,
    isCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.subjectId == this.subjectId &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.mediumThresholdMicros == this.mediumThresholdMicros &&
          other.highThresholdMicros == this.highThresholdMicros &&
          other.criticalThresholdMicros == this.criticalThresholdMicros &&
          other.isCompleted == this.isCompleted);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> subjectId;
  final Value<String> description;
  final Value<DateTime> dueDate;
  final Value<int> mediumThresholdMicros;
  final Value<int> highThresholdMicros;
  final Value<int> criticalThresholdMicros;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.mediumThresholdMicros = const Value.absent(),
    this.highThresholdMicros = const Value.absent(),
    this.criticalThresholdMicros = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    required String subjectId,
    this.description = const Value.absent(),
    required DateTime dueDate,
    required int mediumThresholdMicros,
    required int highThresholdMicros,
    required int criticalThresholdMicros,
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       subjectId = Value(subjectId),
       dueDate = Value(dueDate),
       mediumThresholdMicros = Value(mediumThresholdMicros),
       highThresholdMicros = Value(highThresholdMicros),
       criticalThresholdMicros = Value(criticalThresholdMicros);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subjectId,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<int>? mediumThresholdMicros,
    Expression<int>? highThresholdMicros,
    Expression<int>? criticalThresholdMicros,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subjectId != null) 'subject_id': subjectId,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (mediumThresholdMicros != null)
        'medium_threshold_micros': mediumThresholdMicros,
      if (highThresholdMicros != null)
        'high_threshold_micros': highThresholdMicros,
      if (criticalThresholdMicros != null)
        'critical_threshold_micros': criticalThresholdMicros,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? subjectId,
    Value<String>? description,
    Value<DateTime>? dueDate,
    Value<int>? mediumThresholdMicros,
    Value<int>? highThresholdMicros,
    Value<int>? criticalThresholdMicros,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      mediumThresholdMicros:
          mediumThresholdMicros ?? this.mediumThresholdMicros,
      highThresholdMicros: highThresholdMicros ?? this.highThresholdMicros,
      criticalThresholdMicros:
          criticalThresholdMicros ?? this.criticalThresholdMicros,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (mediumThresholdMicros.present) {
      map['medium_threshold_micros'] = Variable<int>(
        mediumThresholdMicros.value,
      );
    }
    if (highThresholdMicros.present) {
      map['high_threshold_micros'] = Variable<int>(highThresholdMicros.value);
    }
    if (criticalThresholdMicros.present) {
      map['critical_threshold_micros'] = Variable<int>(
        criticalThresholdMicros.value,
      );
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('mediumThresholdMicros: $mediumThresholdMicros, ')
          ..write('highThresholdMicros: $highThresholdMicros, ')
          ..write('criticalThresholdMicros: $criticalThresholdMicros, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyMaterialsTableTable extends StudyMaterialsTable
    with TableInfo<$StudyMaterialsTableTable, StudyMaterialsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyMaterialsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StudyMaterialType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StudyMaterialType>(
        $StudyMaterialsTableTable.$convertertype,
      );
  static const VerificationMeta _resourceLocationMeta = const VerificationMeta(
    'resourceLocation',
  );
  @override
  late final GeneratedColumn<String> resourceLocation = GeneratedColumn<String>(
    'resource_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subjectId,
    description,
    type,
    resourceLocation,
    fileName,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_materials_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyMaterialsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('resource_location')) {
      context.handle(
        _resourceLocationMeta,
        resourceLocation.isAcceptableOrUnknown(
          data['resource_location']!,
          _resourceLocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resourceLocationMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyMaterialsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyMaterialsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: $StudyMaterialsTableTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      resourceLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resource_location'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $StudyMaterialsTableTable createAlias(String alias) {
    return $StudyMaterialsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StudyMaterialType, String, String> $convertertype =
      const EnumNameConverter<StudyMaterialType>(StudyMaterialType.values);
}

class StudyMaterialsTableData extends DataClass
    implements Insertable<StudyMaterialsTableData> {
  final String id;
  final String title;
  final String subjectId;
  final String description;
  final StudyMaterialType type;
  final String resourceLocation;
  final String? fileName;
  final DateTime addedAt;
  const StudyMaterialsTableData({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.description,
    required this.type,
    required this.resourceLocation,
    this.fileName,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['subject_id'] = Variable<String>(subjectId);
    map['description'] = Variable<String>(description);
    {
      map['type'] = Variable<String>(
        $StudyMaterialsTableTable.$convertertype.toSql(type),
      );
    }
    map['resource_location'] = Variable<String>(resourceLocation);
    if (!nullToAbsent || fileName != null) {
      map['file_name'] = Variable<String>(fileName);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  StudyMaterialsTableCompanion toCompanion(bool nullToAbsent) {
    return StudyMaterialsTableCompanion(
      id: Value(id),
      title: Value(title),
      subjectId: Value(subjectId),
      description: Value(description),
      type: Value(type),
      resourceLocation: Value(resourceLocation),
      fileName: fileName == null && nullToAbsent
          ? const Value.absent()
          : Value(fileName),
      addedAt: Value(addedAt),
    );
  }

  factory StudyMaterialsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyMaterialsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      description: serializer.fromJson<String>(json['description']),
      type: $StudyMaterialsTableTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      resourceLocation: serializer.fromJson<String>(json['resourceLocation']),
      fileName: serializer.fromJson<String?>(json['fileName']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subjectId': serializer.toJson<String>(subjectId),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(
        $StudyMaterialsTableTable.$convertertype.toJson(type),
      ),
      'resourceLocation': serializer.toJson<String>(resourceLocation),
      'fileName': serializer.toJson<String?>(fileName),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  StudyMaterialsTableData copyWith({
    String? id,
    String? title,
    String? subjectId,
    String? description,
    StudyMaterialType? type,
    String? resourceLocation,
    Value<String?> fileName = const Value.absent(),
    DateTime? addedAt,
  }) => StudyMaterialsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    subjectId: subjectId ?? this.subjectId,
    description: description ?? this.description,
    type: type ?? this.type,
    resourceLocation: resourceLocation ?? this.resourceLocation,
    fileName: fileName.present ? fileName.value : this.fileName,
    addedAt: addedAt ?? this.addedAt,
  );
  StudyMaterialsTableData copyWithCompanion(StudyMaterialsTableCompanion data) {
    return StudyMaterialsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      resourceLocation: data.resourceLocation.present
          ? data.resourceLocation.value
          : this.resourceLocation,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('resourceLocation: $resourceLocation, ')
          ..write('fileName: $fileName, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subjectId,
    description,
    type,
    resourceLocation,
    fileName,
    addedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyMaterialsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.subjectId == this.subjectId &&
          other.description == this.description &&
          other.type == this.type &&
          other.resourceLocation == this.resourceLocation &&
          other.fileName == this.fileName &&
          other.addedAt == this.addedAt);
}

class StudyMaterialsTableCompanion
    extends UpdateCompanion<StudyMaterialsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> subjectId;
  final Value<String> description;
  final Value<StudyMaterialType> type;
  final Value<String> resourceLocation;
  final Value<String?> fileName;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const StudyMaterialsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.resourceLocation = const Value.absent(),
    this.fileName = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyMaterialsTableCompanion.insert({
    required String id,
    required String title,
    required String subjectId,
    this.description = const Value.absent(),
    required StudyMaterialType type,
    required String resourceLocation,
    this.fileName = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       subjectId = Value(subjectId),
       type = Value(type),
       resourceLocation = Value(resourceLocation),
       addedAt = Value(addedAt);
  static Insertable<StudyMaterialsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subjectId,
    Expression<String>? description,
    Expression<String>? type,
    Expression<String>? resourceLocation,
    Expression<String>? fileName,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subjectId != null) 'subject_id': subjectId,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (resourceLocation != null) 'resource_location': resourceLocation,
      if (fileName != null) 'file_name': fileName,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyMaterialsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? subjectId,
    Value<String>? description,
    Value<StudyMaterialType>? type,
    Value<String>? resourceLocation,
    Value<String?>? fileName,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return StudyMaterialsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      description: description ?? this.description,
      type: type ?? this.type,
      resourceLocation: resourceLocation ?? this.resourceLocation,
      fileName: fileName ?? this.fileName,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $StudyMaterialsTableTable.$convertertype.toSql(type.value),
      );
    }
    if (resourceLocation.present) {
      map['resource_location'] = Variable<String>(resourceLocation.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyMaterialsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subjectId: $subjectId, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('resourceLocation: $resourceLocation, ')
          ..write('fileName: $fileName, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTableTable subjectsTable = $SubjectsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $StudyMaterialsTableTable studyMaterialsTable =
      $StudyMaterialsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjectsTable,
    tasksTable,
    studyMaterialsTable,
  ];
}

typedef $$SubjectsTableTableCreateCompanionBuilder =
    SubjectsTableCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      Value<int> rowid,
    });
typedef $$SubjectsTableTableUpdateCompanionBuilder =
    SubjectsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<int> rowid,
    });

class $$SubjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTableTable> {
  $$SubjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$SubjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTableTable,
          SubjectsTableData,
          $$SubjectsTableTableFilterComposer,
          $$SubjectsTableTableOrderingComposer,
          $$SubjectsTableTableAnnotationComposer,
          $$SubjectsTableTableCreateCompanionBuilder,
          $$SubjectsTableTableUpdateCompanionBuilder,
          (
            SubjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $SubjectsTableTable,
              SubjectsTableData
            >,
          ),
          SubjectsTableData,
          PrefetchHooks Function()
        > {
  $$SubjectsTableTableTableManager(_$AppDatabase db, $SubjectsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsTableCompanion(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubjectsTableTable, SubjectsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SubjectsTableTable,
                    SubjectsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTableTable,
      SubjectsTableData,
      $$SubjectsTableTableFilterComposer,
      $$SubjectsTableTableOrderingComposer,
      $$SubjectsTableTableAnnotationComposer,
      $$SubjectsTableTableCreateCompanionBuilder,
      $$SubjectsTableTableUpdateCompanionBuilder,
      (
        SubjectsTableData,
        BaseReferences<_$AppDatabase, $SubjectsTableTable, SubjectsTableData>,
      ),
      SubjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      required String subjectId,
      Value<String> description,
      required DateTime dueDate,
      required int mediumThresholdMicros,
      required int highThresholdMicros,
      required int criticalThresholdMicros,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> subjectId,
      Value<String> description,
      Value<DateTime> dueDate,
      Value<int> mediumThresholdMicros,
      Value<int> highThresholdMicros,
      Value<int> criticalThresholdMicros,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediumThresholdMicros => $composableBuilder(
    column: $table.mediumThresholdMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highThresholdMicros => $composableBuilder(
    column: $table.highThresholdMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get criticalThresholdMicros => $composableBuilder(
    column: $table.criticalThresholdMicros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediumThresholdMicros => $composableBuilder(
    column: $table.mediumThresholdMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highThresholdMicros => $composableBuilder(
    column: $table.highThresholdMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get criticalThresholdMicros => $composableBuilder(
    column: $table.criticalThresholdMicros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get mediumThresholdMicros => $composableBuilder(
    column: $table.mediumThresholdMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get highThresholdMicros => $composableBuilder(
    column: $table.highThresholdMicros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get criticalThresholdMicros => $composableBuilder(
    column: $table.criticalThresholdMicros,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TasksTableData,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (
            TasksTableData,
            BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
          ),
          TasksTableData,
          PrefetchHooks Function()
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> mediumThresholdMicros = const Value.absent(),
                Value<int> highThresholdMicros = const Value.absent(),
                Value<int> criticalThresholdMicros = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                subjectId: subjectId,
                description: description,
                dueDate: dueDate,
                mediumThresholdMicros: mediumThresholdMicros,
                highThresholdMicros: highThresholdMicros,
                criticalThresholdMicros: criticalThresholdMicros,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String subjectId,
                Value<String> description = const Value.absent(),
                required DateTime dueDate,
                required int mediumThresholdMicros,
                required int highThresholdMicros,
                required int criticalThresholdMicros,
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                subjectId: subjectId,
                description: description,
                dueDate: dueDate,
                mediumThresholdMicros: mediumThresholdMicros,
                highThresholdMicros: highThresholdMicros,
                criticalThresholdMicros: criticalThresholdMicros,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTableTable, TasksTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TasksTableTable,
                    TasksTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TasksTableData,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (
        TasksTableData,
        BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
      ),
      TasksTableData,
      PrefetchHooks Function()
    >;
typedef $$StudyMaterialsTableTableCreateCompanionBuilder =
    StudyMaterialsTableCompanion Function({
      required String id,
      required String title,
      required String subjectId,
      Value<String> description,
      required StudyMaterialType type,
      required String resourceLocation,
      Value<String?> fileName,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$StudyMaterialsTableTableUpdateCompanionBuilder =
    StudyMaterialsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> subjectId,
      Value<String> description,
      Value<StudyMaterialType> type,
      Value<String> resourceLocation,
      Value<String?> fileName,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$StudyMaterialsTableTableFilterComposer
    extends Composer<_$AppDatabase, $StudyMaterialsTableTable> {
  $$StudyMaterialsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StudyMaterialType, StudyMaterialType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get resourceLocation => $composableBuilder(
    column: $table.resourceLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyMaterialsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyMaterialsTableTable> {
  $$StudyMaterialsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resourceLocation => $composableBuilder(
    column: $table.resourceLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyMaterialsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyMaterialsTableTable> {
  $$StudyMaterialsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StudyMaterialType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get resourceLocation => $composableBuilder(
    column: $table.resourceLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$StudyMaterialsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyMaterialsTableTable,
          StudyMaterialsTableData,
          $$StudyMaterialsTableTableFilterComposer,
          $$StudyMaterialsTableTableOrderingComposer,
          $$StudyMaterialsTableTableAnnotationComposer,
          $$StudyMaterialsTableTableCreateCompanionBuilder,
          $$StudyMaterialsTableTableUpdateCompanionBuilder,
          (
            StudyMaterialsTableData,
            BaseReferences<
              _$AppDatabase,
              $StudyMaterialsTableTable,
              StudyMaterialsTableData
            >,
          ),
          StudyMaterialsTableData,
          PrefetchHooks Function()
        > {
  $$StudyMaterialsTableTableTableManager(
    _$AppDatabase db,
    $StudyMaterialsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyMaterialsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyMaterialsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudyMaterialsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<StudyMaterialType> type = const Value.absent(),
                Value<String> resourceLocation = const Value.absent(),
                Value<String?> fileName = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialsTableCompanion(
                id: id,
                title: title,
                subjectId: subjectId,
                description: description,
                type: type,
                resourceLocation: resourceLocation,
                fileName: fileName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String subjectId,
                Value<String> description = const Value.absent(),
                required StudyMaterialType type,
                required String resourceLocation,
                Value<String?> fileName = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyMaterialsTableCompanion.insert(
                id: id,
                title: title,
                subjectId: subjectId,
                description: description,
                type: type,
                resourceLocation: resourceLocation,
                fileName: fileName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StudyMaterialsTableTable,
                    StudyMaterialsTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StudyMaterialsTableTable,
                    StudyMaterialsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyMaterialsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyMaterialsTableTable,
      StudyMaterialsTableData,
      $$StudyMaterialsTableTableFilterComposer,
      $$StudyMaterialsTableTableOrderingComposer,
      $$StudyMaterialsTableTableAnnotationComposer,
      $$StudyMaterialsTableTableCreateCompanionBuilder,
      $$StudyMaterialsTableTableUpdateCompanionBuilder,
      (
        StudyMaterialsTableData,
        BaseReferences<
          _$AppDatabase,
          $StudyMaterialsTableTable,
          StudyMaterialsTableData
        >,
      ),
      StudyMaterialsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableTableManager get subjectsTable =>
      $$SubjectsTableTableTableManager(_db, _db.subjectsTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$StudyMaterialsTableTableTableManager get studyMaterialsTable =>
      $$StudyMaterialsTableTableTableManager(_db, _db.studyMaterialsTable);
}
