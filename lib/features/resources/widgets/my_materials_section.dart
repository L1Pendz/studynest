import 'package:flutter/material.dart';

import '../models/study_material.dart';

class MyMaterialsSection extends StatelessWidget {
  final List<StudyMaterial> materials;
  final TextEditingController searchController;
  final String searchQuery;
  final bool hasFilters;
  final bool filterIsActive;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onShowFilter;
  final IndexedWidgetBuilder itemBuilder;

  const MyMaterialsSection({
    super.key,
    required this.materials,
    required this.searchController,
    required this.searchQuery,
    required this.hasFilters,
    required this.filterIsActive,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onShowFilter,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search materials...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: onClearSearch,
                      icon: const Icon(Icons.close),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black87, width: 1.5),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: onShowFilter,
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
              if (filterIsActive) ...[
                const SizedBox(width: 10),
                Text(
                  '1 active',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: materials.isEmpty
              ? Center(
                  child: Text(
                    hasFilters
                        ? 'No materials found.'
                        : 'No materials yet. Tap + to add one.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  itemCount: materials.length,
                  itemBuilder: itemBuilder,
                ),
        ),
      ],
    );
  }
}
