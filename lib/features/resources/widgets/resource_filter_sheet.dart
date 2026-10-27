import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../../../utils/subject_ordering.dart';

class ResourceFilterSheet extends StatefulWidget {
  final List<Subject> subjects;
  final String? selectedSubjectId;

  const ResourceFilterSheet({
    super.key,
    required this.subjects,
    required this.selectedSubjectId,
  });

  @override
  State<ResourceFilterSheet> createState() => _ResourceFilterSheetState();
}

class _ResourceFilterSheetState extends State<ResourceFilterSheet> {
  late String? _draftSubjectId = widget.selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    final subjectsInPickerOrder = orderSubjectsForPicker(widget.subjects);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String?>(
            initialValue: _draftSubjectId,
            decoration: InputDecoration(labelText: 'Subject'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('All Subjects'),
              ),
              ...subjectsInPickerOrder.map(
                (subject) => DropdownMenuItem<String?>(
                  value: subject.id,
                  child: Text(subject.name),
                ),
              ),
            ],
            onChanged: (value) => setState(() => _draftSubjectId = value),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _draftSubjectId = null),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, <String, String?>{
                    'subjectId': _draftSubjectId,
                  }),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
