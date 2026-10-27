import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';
import '../../../models/task.dart';
import '../widgets/task_form_fields.dart';
import '../widgets/task_threshold_section.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final List<Subject> subjects;

  const TaskFormScreen({super.key, this.task, required this.subjects});

  bool get isEditing => task != null;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String? _selectedSubjectId;
  DateTime? _dueDate;

  int _mediumThreshold = 7;
  int _highThreshold = 3;
  int _criticalThreshold = 1;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task?.title ?? '');

    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );

    _selectedSubjectId = widget.task?.subjectId;
    _dueDate = widget.task?.dueDate;

    _mediumThreshold = widget.task?.mediumThreshold.inDays ?? 7;
    _highThreshold = widget.task?.highThreshold.inDays ?? 3;
    _criticalThreshold = widget.task?.criticalThreshold.inDays ?? 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvas,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.isEditing ? 'Edit Task' : 'Add Task',
          style: const TextStyle(
            color: AppTheme.ink,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            TaskTitleField(controller: _titleController),
            const SizedBox(height: 18),
            TaskSubjectDropdown(
              subjects: widget.subjects,
              selectedSubjectId: _selectedSubjectId,
              onChanged: (value) {
                setState(() {
                  _selectedSubjectId = value;
                });
              },
            ),
            const SizedBox(height: 18),
            TaskDescriptionField(controller: _descriptionController),
            const SizedBox(height: 18),
            TaskDueDateField(dueDate: _dueDate, onTap: _selectDueDate),
            const SizedBox(height: 24),
            TaskThresholdSection(
              mediumThreshold: _mediumThreshold,
              highThreshold: _highThreshold,
              criticalThreshold: _criticalThreshold,
              onMediumChanged: (value) {
                setState(() {
                  _mediumThreshold = value;
                });
              },
              onHighChanged: (value) {
                setState(() {
                  _highThreshold = value;
                });
              },
              onCriticalChanged: (value) {
                setState(() {
                  _criticalThreshold = value;
                });
              },
            ),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                widget.isEditing ? 'Save Changes' : 'Save Task',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );

    if (!mounted || selectedDate == null) return;

    setState(() {
      _dueDate = selectedDate;
    });
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline.')),
      );
      return;
    }

    if (_selectedSubjectId == null) {
      return;
    }

    if (!(_mediumThreshold > _highThreshold &&
        _highThreshold > _criticalThreshold)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thresholds must follow Medium > High > Critical.'),
        ),
      );
      return;
    }

    final task =
        widget.task?.copyWith(
          title: _titleController.text.trim(),
          subjectId: _selectedSubjectId,
          description: _descriptionController.text.trim(),
          dueDate: _dueDate,
          mediumThreshold: Duration(days: _mediumThreshold),
          highThreshold: Duration(days: _highThreshold),
          criticalThreshold: Duration(days: _criticalThreshold),
        ) ??
        Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          subjectId: _selectedSubjectId!,
          description: _descriptionController.text.trim(),
          dueDate: _dueDate!,
          mediumThreshold: Duration(days: _mediumThreshold),
          highThreshold: Duration(days: _highThreshold),
          criticalThreshold: Duration(days: _criticalThreshold),
        );

    Navigator.pop(context, task);
  }
}
