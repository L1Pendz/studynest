import 'package:flutter/material.dart';

import '../data/app_database.dart';

class SavedDataErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final ValueChanged<SavedDataSection> onResetSection;
  final VoidCallback onResetAll;

  const SavedDataErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onResetSection,
    required this.onResetAll,
  });

  @override
  Widget build(BuildContext context) {
    final failedSection = error is SavedDataLoadException
        ? (error as SavedDataLoadException).section
        : null;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                failedSection == null
                    ? 'Could not load saved StudyNest data.'
                    : 'Could not load saved ${failedSection.name}.',
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                  if (failedSection != null)
                    FilledButton(
                      onPressed: () => onResetSection(failedSection),
                      child: Text(switch (failedSection) {
                        SavedDataSection.subjects => 'Reset Subjects',
                        SavedDataSection.tasks => 'Reset Tasks',
                        SavedDataSection.materials => 'Reset Materials',
                      }),
                    ),
                  FilledButton(
                    onPressed: onResetAll,
                    child: Text(
                      failedSection == SavedDataSection.materials
                          ? 'Reset All Local Data'
                          : 'Reset Local Data',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
