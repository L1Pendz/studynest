import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../widgets/subjects/edit_subject_dialog.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  final List<Subject> subjects;
  final Future<void> Function() onDelete;
  final Future<void> Function(Subject) onUpdate;

  const SubjectDetailsScreen({
    super.key,
    required this.subject,
    required this.subjects,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  late Subject _subject;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
  }

  Future<void> _editSubject() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) =>
          EditSubjectDialog(subject: _subject, subjects: widget.subjects),
    );

    if (!mounted || result == null) return;

    final updatedSubject = _subject.copyWith(
      name: result['name']!,
      description: result['description'] ?? '',
    );

    try {
      await widget.onUpdate(updatedSubject);
      if (!mounted) return;
      setState(() => _subject = updatedSubject);
    } catch (_) {
      _showStorageError();
    }
  }

  Future<void> _deleteSubject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject?'),
          content: Text('Are you sure you want to delete "${_subject.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    try {
      await widget.onDelete();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      _showStorageError();
    }
  }

  void _showStorageError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not save the subject. Try again.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Details'),
        actions: [
          IconButton(
            tooltip: 'Edit subject',
            onPressed: _editSubject,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            tooltip: 'Delete subject',
            onPressed: _deleteSubject,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _subject.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              _subject.description.isEmpty
                  ? 'No description provided.'
                  : _subject.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
