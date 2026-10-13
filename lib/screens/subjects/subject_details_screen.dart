import 'package:flutter/material.dart';

import '../../models/subject.dart';

class SubjectDetailsScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Details')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text('Subject tasks and study materials will appear here.'),
          ],
        ),
      ),
    );
  }
}
