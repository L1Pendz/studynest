import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../widgets/subjects/add_subject_dialog.dart';
import '../../widgets/subjects/subject_card.dart';
import 'subject_details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final List<Subject> initialSubjects;

  const SubjectsScreen({super.key, required this.initialSubjects});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final _searchController = TextEditingController();

  late final List<Subject> _subjects = List.of(widget.initialSubjects);

  String _searchQuery = '';

  List<Subject> get _filteredSubjects {
    return _subjects.where((subject) {
      return subject.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Colors.black87),
            _buildSearchBar(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'My Subjects',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: subjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Add subject',
            onPressed: _showAddSubjectDialog,
            icon: const Icon(Icons.add, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black87, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
        style: TextStyle(color: Colors.grey.shade600),
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

    setState(() {
      _subjects.add(
        Subject(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: name,
          description: description,
        ),
      );
    });
  }

  void _openSubject(Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SubjectDetailsScreen(
          subject: subject,
          subjects: _subjects,
          onDelete: () {
            setState(() {
              _subjects.removeWhere((item) => item.id == subject.id);
            });
          },
          onUpdate: (updatedSubject) {
            setState(() {
              final index = _subjects.indexWhere(
                (item) => item.id == updatedSubject.id,
              );

              if (index != -1) {
                _subjects[index] = updatedSubject;
              }
            });
          },
        ),
      ),
    );
  }
}
