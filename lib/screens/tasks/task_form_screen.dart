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

  static const Color _primaryColor = Color(0xFF8EC9F5);
  static const Color _borderColor = Color(0xFF1F1F1F);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          widget.isEditing ? 'Edit Task' : 'Add Task',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1.5, color: Colors.black87),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 30),
          children: [
            _buildTitleField(),
            const SizedBox(height: 18),
            _buildSubjectDropdown(),
            const SizedBox(height: 18),
            _buildDescriptionField(),
            const SizedBox(height: 18),
            _buildDueDateField(),
            const SizedBox(height: 24),
            _buildUrgencyThresholds(),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Name',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Enter task name...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
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

  Widget _buildSubjectDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subject',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: _selectedSubjectId,
          isExpanded: true,
          hint: const Text('Select subject...'),
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
          items: widget.subjects.map((subject) {
            return DropdownMenuItem(
              value: subject.id,
              child: Text(subject.name),
            );
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
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter task details...',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black87, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
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

  Widget _buildDueDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deadline',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 7),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _selectDueDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: _borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'Select date...'
                        : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                    style: TextStyle(
                      color: _dueDate == null
                          ? Colors.grey.shade600
                          : Colors.black87,
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

  Widget _buildUrgencyThresholds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency Thresholds',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          'Set how many days before the deadline the task changes urgency.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Text(
          'The task becomes more urgent as the deadline gets closer.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _buildThresholdRow(
          label: 'Medium',
          value: _mediumThreshold,
          labelColor: Colors.yellow.shade700,
          onChanged: (value) {
            setState(() {
              _mediumThreshold = value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildThresholdRow(
          label: 'High',
          value: _highThreshold,
          labelColor: Colors.orange,
          onChanged: (value) {
            setState(() {
              _highThreshold = value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildThresholdRow(
          label: 'Critical',
          value: _criticalThreshold,
          labelColor: Colors.red,
          onChanged: (value) {
            setState(() {
              _criticalThreshold = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildThresholdRow({
    required String label,
    required int value,
    required Color labelColor,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _borderColor, width: 1.5),
              ),
            ),
            items: List.generate(30, (index) {
              final days = index + 1;

              return DropdownMenuItem(
                value: days,
                child: Text('$days ${days == 1 ? 'day' : 'days'} left'),
              );
            }),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
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
                backgroundColor: _primaryColor,
                foregroundColor: Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black87, width: 1.3),
                ),
              ),
              child: Text(
                widget.isEditing ? 'Save Changes' : 'Save Task',
                style: const TextStyle(fontWeight: FontWeight.w500),
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
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black87, width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
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
