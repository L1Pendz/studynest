import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({super.key, required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppTheme.outline),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F0FE),
          foregroundColor: AppTheme.primary,
          child: Icon(Icons.menu_book_outlined),
        ),
        title: Text(
          subject.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppTheme.mutedInk,
        ),
        onTap: onTap,
      ),
    );
  }
}
