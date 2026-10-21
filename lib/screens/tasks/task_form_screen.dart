import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/task.dart';

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
      appBar: AppBar(title: Text(widget.isEditing ? 'Edit Task' : 'Add Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTitleField(),
            const SizedBox(height: 20),
            _buildSubjectDropdown(),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildDueDateField(),
            const SizedBox(height: 28),
            _buildUrgencyThresholds(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Task Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a task name.';
        }

        return null;
      },
    );
  }

  Widget _buildSubjectDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSubjectId,
      decoration: const InputDecoration(
        labelText: 'Subject',
        border: OutlineInputBorder(),
      ),
      items: widget.subjects.map((subject) {
        return DropdownMenuItem(value: subject.id, child: Text(subject.name));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSubjectId = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a subject.';
        }

        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Description',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDueDateField() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Deadline'),
      subtitle: Text(
        _dueDate == null
            ? 'No deadline selected'
            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
      ),
      trailing: const Icon(Icons.calendar_today_outlined),
      onTap: _selectDueDate,
    );
  }

  Widget _buildUrgencyThresholds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency Thresholds',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          'Set how many days remain before a task changes urgency.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        _buildThresholdDropdown(
          label: 'Medium',
          value: _mediumThreshold,
          onChanged: (value) {
            setState(() {
              _mediumThreshold = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildThresholdDropdown(
          label: 'High',
          value: _highThreshold,
          onChanged: (value) {
            setState(() {
              _highThreshold = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildThresholdDropdown(
          label: 'Critical',
          value: _criticalThreshold,
          onChanged: (value) {
            setState(() {
              _criticalThreshold = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildThresholdDropdown({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: '$label threshold',
        border: const OutlineInputBorder(),
      ),
      items: List.generate(30, (index) {
        final days = index + 1;

        return DropdownMenuItem(
          value: days,
          child: Text('$days ${days == 1 ? 'day' : 'days'}'),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,
        child: Text(widget.isEditing ? 'Save Changes' : 'Create Task'),
      ),
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
