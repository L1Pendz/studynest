import 'package:flutter/material.dart';

const Color _borderColor = Color(0xFF1F1F1F);

class TaskThresholdSection extends StatelessWidget {
  final int mediumThreshold;
  final int highThreshold;
  final int criticalThreshold;
  final ValueChanged<int> onMediumChanged;
  final ValueChanged<int> onHighChanged;
  final ValueChanged<int> onCriticalChanged;

  const TaskThresholdSection({
    super.key,
    required this.mediumThreshold,
    required this.highThreshold,
    required this.criticalThreshold,
    required this.onMediumChanged,
    required this.onHighChanged,
    required this.onCriticalChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        TaskThresholdRow(
          label: 'Medium',
          value: mediumThreshold,
          labelColor: Colors.yellow.shade700,
          onChanged: onMediumChanged,
        ),
        const SizedBox(height: 10),
        TaskThresholdRow(
          label: 'High',
          value: highThreshold,
          labelColor: Colors.orange,
          onChanged: onHighChanged,
        ),
        const SizedBox(height: 10),
        TaskThresholdRow(
          label: 'Critical',
          value: criticalThreshold,
          labelColor: Colors.red,
          onChanged: onCriticalChanged,
        ),
      ],
    );
  }
}

class TaskThresholdRow extends StatelessWidget {
  final String label;
  final int value;
  final Color labelColor;
  final ValueChanged<int> onChanged;

  const TaskThresholdRow({
    super.key,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
}
