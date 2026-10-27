import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../widgets/edit_subject_dialog.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  final List<Subject> subjects;
  final int pendingTaskCount;
  final Future<void> Function() onDelete;
  final Future<void> Function(Subject) onUpdate;
  final VoidCallback onViewTasks;
  final VoidCallback onViewResources;
  final VoidCallback onFindVideos;

  const SubjectDetailsScreen({
    super.key,
    required this.subject,
    required this.subjects,
    required this.pendingTaskCount,
    required this.onDelete,
    required this.onUpdate,
    required this.onViewTasks,
    required this.onViewResources,
    required this.onFindVideos,
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
      builder: (context) => AlertDialog(
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
      ),
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
      backgroundColor: AppTheme.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  _buildSubjectCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Information',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: AppTheme.ink),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.ink),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _subject.description.trim().isEmpty
                        ? 'No description provided.'
                        : _subject.description,
                    style: const TextStyle(fontSize: 15, height: 1.45, color: AppTheme.mutedInk),
                  ),
                  const SizedBox(height: 24),
                  _buildDestination(
                    icon: Icons.task_alt_outlined,
                    title: 'Tasks',
                    subtitle: 'Pending Tasks: ${widget.pendingTaskCount}',
                    onTap: widget.onViewTasks,
                  ),
                  const SizedBox(height: 14),
                  _buildDestination(
                    icon: Icons.folder_outlined,
                    title: 'Study Resources',
                    onTap: widget.onViewResources,
                  ),
                  const SizedBox(height: 14),
                  _buildDestination(
                    icon: Icons.ondemand_video_outlined,
                    title: 'Find Videos',
                    onTap: widget.onFindVideos,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 28),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Subject Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.ink),
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Subject actions',
            onSelected: (action) {
              if (action == 'edit') _editSubject();
              if (action == 'delete') _deleteSubject();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit Subject')),
              PopupMenuItem(value: 'delete', child: Text('Delete Subject')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.outline),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: const Color(0xFFE8F0FE),
            foregroundColor: AppTheme.primary,
            child: Icon(Icons.menu_book_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _subject.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestination({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE8F0FE),
                foregroundColor: AppTheme.primary,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.ink)),
                    if (subtitle != null)
                      Text(subtitle, style: const TextStyle(fontSize: 13, color: AppTheme.mutedInk)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.mutedInk),
            ],
          ),
        ),
      ),
    );
  }
}
