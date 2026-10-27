import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';

class ResourceDocumentPicker extends StatelessWidget {
  final String? fileName;
  final bool isEditing;
  final VoidCallback onTap;

  const ResourceDocumentPicker({
    super.key,
    required this.fileName,
    required this.isEditing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.ink),
        ),
        const SizedBox(height: 7),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppTheme.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, color: AppTheme.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(fileName ?? 'Select a document...')),
                Icon(
                  isEditing ? Icons.edit_outlined : Icons.keyboard_arrow_down,
                  color: AppTheme.mutedInk,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
