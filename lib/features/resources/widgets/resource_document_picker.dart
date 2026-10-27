import 'package:flutter/material.dart';

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

  static const Color _borderColor = Color(0xFF1F1F1F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: _borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 10),
                Expanded(child: Text(fileName ?? 'Select a document...')),
                Icon(
                  isEditing ? Icons.edit_outlined : Icons.keyboard_arrow_down,
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
