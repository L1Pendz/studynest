import 'package:flutter/material.dart';
import 'package:studynest/utils/subject_ordering.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';

class TaskTitleField extends StatelessWidget {
  final TextEditingController controller;

  const TaskTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Name',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter task name...'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task name.';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class TaskSubjectDropdown extends StatelessWidget {
  final List<Subject> subjects;
  final String? selectedSubjectId;
  final ValueChanged<String?> onChanged;

  const TaskSubjectDropdown({
    super.key,
    required this.subjects,
    required this.selectedSubjectId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final subjectsInPickerOrder = orderSubjectsForPicker(subjects);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: selectedSubjectId,
          isExpanded: true,
          hint: const Text('Select subject...'),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: subjectsInPickerOrder.map((subject) {
            return DropdownMenuItem(
              value: subject.id,
              child: Text(subject.name),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select a subject.';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class TaskDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const TaskDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter task details...',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a description.';
            }

            return null;
          },
        ),
      ],
    );
  }
}

class TaskDueDateField extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;

  const TaskDueDateField({
    super.key,
    required this.dueDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deadline',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
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
                Expanded(
                  child: Text(
                    dueDate == null
                        ? 'Select date...'
                        : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
                    style: TextStyle(
                      color: dueDate == null ? AppTheme.mutedInk : AppTheme.ink,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
