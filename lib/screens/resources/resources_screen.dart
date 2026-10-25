import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../models/study_material.dart';
import '../../models/subject.dart';

class ResourcesScreen extends StatelessWidget {
  final AppDatabase database;
  final List<Subject> subjects;
  final List<StudyMaterial> initialMaterials;

  const ResourcesScreen({
    super.key,
    required this.database,
    required this.subjects,
    required this.initialMaterials,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Your Study Resources'));
  }
}
