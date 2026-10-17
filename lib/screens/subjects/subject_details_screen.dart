import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../widgets/subjects/edit_subject_dialog.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  final List<Subject> subjects;
  final VoidCallback onDelete;

  const SubjectDetailsScreen({
    super.key,
    required this.subject,
    required this.subjects,
    required this.onDelete,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  Future<void> _editSubject() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) =>
          EditSubjectDialog(subject: widget.subject, subjects: widget.subjects),
    );

    if (!mounted || result == null) return;

    setState(() {
      widget.subject.name = result['name']!;
      widget.subject.description = result['description'] ?? '';
    });
  }

  Future<void> _deleteSubject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Subject?'),
          content: Text(
            'Are you sure you want to delete "${widget.subject.name}"?',
          ),
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

    widget.onDelete();
    Navigator.pop(context);
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
              widget.subject.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              widget.subject.description.isEmpty
                  ? 'No description provided.'
                  : widget.subject.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
