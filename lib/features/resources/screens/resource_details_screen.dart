import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/app_database.dart';
import '../data/material_file_storage.dart';
import '../models/study_material.dart';
import '../../../models/subject.dart';
import 'resource_form_screen.dart';

class ResourceDetailsScreen extends StatefulWidget {
  final StudyMaterial material;
  final String subjectName;
  final List<Subject> subjects;
  final AppDatabase database;
  final ValueChanged<StudyMaterial> onMaterialUpdated;
  final Future<void> Function() onDelete;

  const ResourceDetailsScreen({
    super.key,
    required this.material,
    required this.subjectName,
    required this.subjects,
    required this.database,
    required this.onMaterialUpdated,
    required this.onDelete,
  });

  @override
  State<ResourceDetailsScreen> createState() => _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends State<ResourceDetailsScreen> {
  late StudyMaterial _material = widget.material;

  static const Color _cardColor = Color(0xFFF3F7FE);
  static const Color _borderColor = Color(0xFFB5CCE8);
  static const Color _primaryColor = Color(0xFF8EC9F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1, color: Colors.black87),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                children: [
                  _buildMaterialCard(),
                  const SizedBox(height: 24),
                  _buildDetail(label: 'Subject', value: _subjectName),
                  const SizedBox(height: 20),
                  _buildDetail(label: 'Type', value: _typeLabel),
                  const SizedBox(height: 20),
                  _buildDetail(
                    label: 'Date Added',
                    value: _formatDate(_material.addedAt),
                  ),
                  if (_material.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildDetail(
                      label: 'Description',
                      value: _material.description,
                    ),
                  ],
                  const SizedBox(height: 30),
                  _buildActions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subjectName =>
      widget.subjects
          .where((subject) => subject.id == _material.subjectId)
          .map((subject) => subject.name)
          .firstOrNull ??
      widget.subjectName;

  Widget _buildHeader(BuildContext context) {
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
                'Resource Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildMaterialCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1.4),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            child: Icon(
              _material.type == StudyMaterialType.document
                  ? Icons.description_outlined
                  : Icons.link,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _material.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, height: 1.4)),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Colors.black87, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _openMaterial(context),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Resource'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.black87,
              elevation: 0,
              side: const BorderSide(color: Colors.black87, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _editResource,
            child: const Text(
              'Edit Resource',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _confirmDelete(context),
            child: const Text(
              'Delete Resource',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  String get _typeLabel {
    if (_material.type == StudyMaterialType.link) return 'Resource link';
    final fileName = _material.fileName;
    final extension = fileName != null && fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'Document';
    return '$extension document';
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';

  Future<void> _openMaterial(BuildContext context) async {
    try {
      if (_material.type == StudyMaterialType.link) {
        final launched = await launchUrl(
          Uri.parse(_material.resourceLocation),
          mode: LaunchMode.externalApplication,
        );
        if (!launched) throw StateError('Could not open link.');
      } else {
        final result = await OpenFilex.open(_material.resourceLocation);
        if (result.type != ResultType.done) {
          throw StateError(result.message);
        }
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this material.')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resource?'),
        content: Text('Delete "${_material.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    try {
      await widget.onDelete();
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete this resource.')),
      );
    }
  }

  Future<void> _editResource() async {
    final updated = await Navigator.push<StudyMaterial>(
      context,
      MaterialPageRoute<StudyMaterial>(
        builder: (_) => ResourceFormScreen(
          subjects: widget.subjects,
          initialMaterial: _material,
        ),
      ),
    );
    if (!mounted || updated == null) return;

    try {
      await widget.database.saveMaterial(updated);
      if (_material.type == StudyMaterialType.document &&
          updated.resourceLocation != _material.resourceLocation) {
        try {
          await deleteStoredMaterial(_material.resourceLocation);
        } catch (_) {
          // Keep the saved update even if cleanup of the replaced file fails.
        }
      }
      if (!mounted) return;
      setState(() => _material = updated);
      widget.onMaterialUpdated(updated);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Resource updated.')));
    } catch (_) {
      if (updated.type == StudyMaterialType.document &&
          updated.resourceLocation != _material.resourceLocation) {
        try {
          await deleteStoredMaterial(updated.resourceLocation);
        } catch (_) {
          // Cleanup failure should not hide the database update error.
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update this resource.')),
      );
    }
  }
}
