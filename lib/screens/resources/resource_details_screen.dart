import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/study_material.dart';

class ResourceDetailsScreen extends StatelessWidget {
  final StudyMaterial material;
  final String subjectName;

  const ResourceDetailsScreen({
    super.key,
    required this.material,
    required this.subjectName,
  });

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
                  _buildDetail(label: 'Subject', value: subjectName),
                  const SizedBox(height: 20),
                  _buildDetail(label: 'Type', value: _typeLabel),
                  const SizedBox(height: 20),
                  _buildDetail(
                    label: 'Date Added',
                    value: _formatDate(material.addedAt),
                  ),
                  if (material.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildDetail(
                      label: 'Description',
                      value: material.description,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
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
              material.type == StudyMaterialType.document
                  ? Icons.description_outlined
                  : Icons.link,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              material.title,
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
    return SizedBox(
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
        onPressed: () => _openMaterial(context),
        child: const Text(
          'Open Resource',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String get _typeLabel {
    if (material.type == StudyMaterialType.link) return 'Resource link';
    final fileName = material.fileName;
    final extension = fileName != null && fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'Document';
    return '$extension document';
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';

  Future<void> _openMaterial(BuildContext context) async {
    try {
      if (material.type == StudyMaterialType.link) {
        final launched = await launchUrl(
          Uri.parse(material.resourceLocation),
          mode: LaunchMode.externalApplication,
        );
        if (!launched) throw StateError('Could not open link.');
      } else {
        final result = await OpenFilex.open(material.resourceLocation);
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
}
