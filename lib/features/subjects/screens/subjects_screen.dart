import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../data/app_database.dart';
import '../../../models/subject.dart';
import '../widgets/add_subject_dialog.dart';
import '../widgets/subject_card.dart';
import 'subject_details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final AppDatabase database;
  final List<Subject> initialSubjects;
  final Future<void> Function() onSubjectsChanged;
  final Map<String, int> pendingTaskCounts;
  final ValueChanged<String> onViewTasks;
  final ValueChanged<String> onViewResources;
  final ValueChanged<String> onFindVideos;

  const SubjectsScreen({
    super.key,
    required this.database,
    required this.initialSubjects,
    required this.onSubjectsChanged,
    required this.pendingTaskCounts,
    required this.onViewTasks,
    required this.onViewResources,
    required this.onFindVideos,
  });

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final _searchController = TextEditingController();

  late List<Subject> _subjects = List.of(widget.initialSubjects);

  String _searchQuery = '';

  @override
  void didUpdateWidget(covariant SubjectsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.initialSubjects, widget.initialSubjects)) {
      _subjects = List.of(widget.initialSubjects);
    }
  }

  List<Subject> get _filteredSubjects {
    return _subjects.where((subject) {
      return !subject.isNoSubject &&
          subject.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _filteredSubjects;

    return Scaffold(
      backgroundColor: AppTheme.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'My Subjects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.ink,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: subjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjects[index];

                        return SubjectCard(
                          subject: subject,
                          onTap: () => _openSubject(subject),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Subjects',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add subject',
            onPressed: _showAddSubjectDialog,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.add, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search subjects...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        _searchQuery.isEmpty
            ? 'No subjects yet. Tap + to add one.'
            : 'No subjects found.',
        style: const TextStyle(color: AppTheme.mutedInk),
      ),
    );
  }

  Future<void> _showAddSubjectDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AddSubjectDialog(subjects: _subjects),
    );

    if (!mounted || result == null) return;

    final name = result['name']!;
    final description = result['description'] ?? '';
    final subject = Subject(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );

    try {
      await widget.database.saveSubject(subject);
      if (!mounted) return;
      setState(() => _subjects.add(subject));
      await widget.onSubjectsChanged();
    } catch (_) {
      _showStorageError();
    }
  }

  void _openSubject(Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SubjectDetailsScreen(
          subject: subject,
          subjects: _subjects,
          pendingTaskCount: widget.pendingTaskCounts[subject.id] ?? 0,
          onViewTasks: () => widget.onViewTasks(subject.id),
          onViewResources: () => widget.onViewResources(subject.id),
          onFindVideos: () => widget.onFindVideos(subject.id),
          onDelete: () async {
            await widget.database.deleteSubject(subject.id);
            if (!mounted) return;
            setState(() {
              _subjects.removeWhere((item) => item.id == subject.id);
            });
            await widget.onSubjectsChanged();
          },
          onUpdate: (updatedSubject) async {
            await widget.database.saveSubject(updatedSubject);
            if (!mounted) return;
            setState(() {
              final index = _subjects.indexWhere(
                (item) => item.id == updatedSubject.id,
              );

              if (index != -1) {
                _subjects[index] = updatedSubject;
              }
            });
            await widget.onSubjectsChanged();
          },
        ),
      ),
    );
  }

  void _showStorageError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not save the subject. Try again.')),
    );
  }
}
