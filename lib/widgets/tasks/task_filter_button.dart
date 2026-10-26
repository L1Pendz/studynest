import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';

class TaskFilterSelection {
  const TaskFilterSelection({
    this.subjectId,
    this.urgency,
    this.completionStatus,
  });

  final String? subjectId;
  final TaskUrgency? urgency;
  final bool? completionStatus;
}

class TaskFilterButton extends StatelessWidget {
  const TaskFilterButton({
    required this.subjects,
    required this.selectedSubjectId,
    required this.selectedUrgency,
    required this.selectedCompletionStatus,
    required this.onApply,
    super.key,
  });

  final List<Subject> subjects;
  final String? selectedSubjectId;
  final TaskUrgency? selectedUrgency;
  final bool? selectedCompletionStatus;
  final ValueChanged<TaskFilterSelection> onApply;

  @override
  Widget build(BuildContext context) {
    final filterCount = [
      selectedSubjectId != null,
      selectedUrgency != null,
      selectedCompletionStatus != null,
    ].where((filter) => filter).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () => _showFilterSheet(context),
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Colors.black87, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (filterCount > 0) ...[
            const SizedBox(width: 10),
            Text(
              '$filterCount active',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final selection = await showModalBottomSheet<TaskFilterSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TaskFilterSheetContent(
        subjects: subjects,
        initialSelection: TaskFilterSelection(
          subjectId: selectedSubjectId,
          urgency: selectedUrgency,
          completionStatus: selectedCompletionStatus,
        ),
      ),
    );

    if (selection != null) {
      onApply(selection);
    }
  }
}

class _TaskFilterSheetContent extends StatefulWidget {
  const _TaskFilterSheetContent({
    required this.subjects,
    required this.initialSelection,
  });

  final List<Subject> subjects;
  final TaskFilterSelection initialSelection;

  @override
  State<_TaskFilterSheetContent> createState() =>
      _TaskFilterSheetContentState();
}

class _TaskFilterSheetContentState extends State<_TaskFilterSheetContent> {
  late String? _subjectId = widget.initialSelection.subjectId;
  late TaskUrgency? _urgency = widget.initialSelection.urgency;
  late bool? _completionStatus = widget.initialSelection.completionStatus;

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildSubjectFilter(),
          const SizedBox(height: 16),
          _buildUrgencyFilter(),
          const SizedBox(height: 16),
          _buildCompletionFilter(),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Filters',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSubjectFilter() {
    final subjectsInPickerOrder = [
      ...widget.subjects.where((subject) => subject.isNoSubject),
      ...widget.subjects.where((subject) => !subject.isNoSubject),
    ];

    return DropdownButtonFormField<String?>(
      initialValue: _subjectId,
      decoration: InputDecoration(
        labelText: 'Subject',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
      ),
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
      onChanged: (value) => setState(() => _subjectId = value),
    );
  }

  Widget _buildUrgencyFilter() {
    return DropdownButtonFormField<TaskUrgency?>(
      initialValue: _urgency,
      decoration: InputDecoration(
        labelText: 'Urgency',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem<TaskUrgency?>(
          value: null,
          child: Text('All Urgencies'),
        ),
        DropdownMenuItem<TaskUrgency?>(
          value: TaskUrgency.low,
          child: Text('Low'),
        ),
        DropdownMenuItem<TaskUrgency?>(
          value: TaskUrgency.medium,
          child: Text('Medium'),
        ),
        DropdownMenuItem<TaskUrgency?>(
          value: TaskUrgency.high,
          child: Text('High'),
        ),
        DropdownMenuItem<TaskUrgency?>(
          value: TaskUrgency.critical,
          child: Text('Critical'),
        ),
      ],
      onChanged: (value) => setState(() => _urgency = value),
    );
  }

  Widget _buildCompletionFilter() {
    return DropdownButtonFormField<bool?>(
      initialValue: _completionStatus,
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem<bool?>(value: null, child: Text('All Tasks')),
        DropdownMenuItem<bool?>(value: false, child: Text('Incomplete')),
        DropdownMenuItem<bool?>(value: true, child: Text('Completed')),
      ],
      onChanged: (value) => setState(() => _completionStatus = value),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _subjectId = null;
                _urgency = null;
                _completionStatus = null;
              });
            },
            child: const Text('Clear'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                TaskFilterSelection(
                  subjectId: _subjectId,
                  urgency: _urgency,
                  completionStatus: _completionStatus,
                ),
              );
            },
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
