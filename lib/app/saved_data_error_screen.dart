import 'package:flutter/material.dart';

import 'app_theme.dart';
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
      backgroundColor: AppTheme.canvas,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2DF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.cloud_off_outlined,
                    size: 34,
                    color: Color(0xFF9A5B00),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  failedSection == null
                      ? 'Could not load saved StudyNest data.'
                      : 'Could not load saved ${failedSection.name}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 22),
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
      ),
    );
  }
}
