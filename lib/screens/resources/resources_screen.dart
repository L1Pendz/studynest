import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/app_database.dart';
import '../../data/material_file_storage.dart';
import '../../models/study_material.dart';
import '../../models/subject.dart';
import '../../models/video_search_result.dart';
import '../../services/youtube_video_search_service.dart';
import 'add_material_screen.dart';
import 'resource_details_screen.dart';

class ResourcesScreen extends StatefulWidget {
  final AppDatabase database;
  final List<Subject> subjects;
  final List<StudyMaterial> initialMaterials;

  const ResourcesScreen({
    super.key,
    required this.database,
    required this.subjects,
    required this.initialMaterials,
  });

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final _searchController = TextEditingController();
  final _videoSearchController = TextEditingController();
  final _videoSearchService = YouTubeVideoSearchService();
  late List<StudyMaterial> _materials = List.of(widget.initialMaterials);
  String _searchQuery = '';
  String? _selectedSubjectId;
  bool _showVideos = false;
  String _videoQuery = '';
  List<VideoSearchResult> _videos = [];
  bool _isSearchingVideos = false;
  String? _videoError;

  @override
  void didUpdateWidget(covariant ResourcesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.initialMaterials, widget.initialMaterials)) {
      _materials = List.of(widget.initialMaterials);
    }
    if (_selectedSubjectId != null &&
        !widget.subjects.any((subject) => subject.id == _selectedSubjectId)) {
      _selectedSubjectId = null;
    }
  }

  List<StudyMaterial> get _filteredMaterials {
    return _materials.where((material) {
      final matchesSearch = material.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesSubject =
          _selectedSubjectId == null ||
          material.subjectId == _selectedSubjectId;
      return matchesSearch && matchesSubject;
    }).toList()..sort((a, b) => b.addedAt.compareTo(a.addedAt));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _videoSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materials = _filteredMaterials;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Colors.black87),
            _buildResourceTabs(),
            if (_showVideos) ...[
              _buildVideoSearchField(),
              Expanded(child: _buildVideoResults()),
            ] else ...[
              _buildSearchField(),
              _buildFilterButton(),
              Expanded(
                child: materials.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          final material = materials[index];
                          return _buildMaterialCard(material);
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Study Resources',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            tooltip: 'Add material',
            onPressed: _addMaterial,
            icon: const Icon(Icons.add, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          _resourceTab(
            'My Materials',
            selected: !_showVideos,
            onTap: () => setState(() => _showVideos = false),
          ),
          _resourceTab(
            'Find Videos',
            selected: _showVideos,
            onTap: () => setState(() => _showVideos = true),
          ),
        ],
      ),
    );
  }

  Widget _resourceTab(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: selected ? const Color(0xFF8EC9F5) : Colors.white,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black87, width: 1.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildVideoSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: TextField(
        controller: _videoSearchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _searchVideos,
        decoration: InputDecoration(
          hintText: 'Search YouTube for educational videos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            tooltip: 'Search videos',
            onPressed: () => _searchVideos(_videoSearchController.text),
            icon: const Icon(Icons.arrow_forward),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black87, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoResults() {
    if (_isSearchingVideos) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_videoError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_videoError!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _searchVideos(_videoQuery),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (_videoQuery.isEmpty || _videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.ondemand_video_outlined,
                size: 48,
                color: Colors.blueGrey.shade300,
              ),
              const SizedBox(height: 12),
              Text(
                _videoQuery.isEmpty
                    ? 'Search for a subject or study topic to find videos.'
                    : 'No videos found. Try another search.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      itemCount: _videos.length,
      itemBuilder: (context, index) => _buildVideoCard(_videos[index]),
    );
  }

  Widget _buildVideoCard(VideoSearchResult video) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF3F7FE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFB5CCE8)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openVideo(video),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 112,
                  height: 76,
                  child: video.thumbnailUrl.isEmpty
                      ? const ColoredBox(
                          color: Color(0xFFE4EBF4),
                          child: Icon(Icons.ondemand_video_outlined),
                        )
                      : Image.network(
                          video.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) =>
                              const ColoredBox(
                                color: Color(0xFFE4EBF4),
                                child: Icon(Icons.broken_image_outlined),
                              ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      video.channelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    if (video.publishedAt != null)
                      Text(
                        'Published ${_formatDate(video.publishedAt!)}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchVideos(String value) async {
    final query = value.trim();
    if (query.isEmpty || _isSearchingVideos) return;
    setState(() {
      _videoQuery = query;
      _isSearchingVideos = true;
      _videoError = null;
      _videos = [];
    });
    try {
      final videos = await _videoSearchService.search(query);
      if (!mounted) return;
      setState(() => _videos = videos);
    } catch (error) {
      if (!mounted) return;
      setState(() => _videoError = error.toString());
    } finally {
      if (mounted) setState(() => _isSearchingVideos = false);
    }
  }

  Future<void> _openVideo(VideoSearchResult video) async {
    try {
      final opened = await launchUrl(
        video.watchUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) throw StateError('Could not open video');
    } catch (_) {
      _showMessage('Could not open this video.');
    }
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value.trim()),
        decoration: InputDecoration(
          hintText: 'Search materials...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  icon: const Icon(Icons.close),
                ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black87, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    final filterIsActive = _selectedSubjectId != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: _showFilterSheet,
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
    );
  }

  Future<void> _showFilterSheet() async {
    final subjectsInPickerOrder = [
      ...widget.subjects.where((subject) => subject.isNoSubject),
      ...widget.subjects.where((subject) => !subject.isNoSubject),
    ];

    final selection = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var draftSubjectId = _selectedSubjectId;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String?>(
                    initialValue: draftSubjectId,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Subjects'),
                      ),
                      ...subjectsInPickerOrder.map(
                        (subject) => DropdownMenuItem<String?>(
                          value: subject.id,
                          child: Text(subject.name),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setSheetState(() => draftSubjectId = value),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              setSheetState(() => draftSubjectId = null),
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(
                            context,
                            <String, String?>{'subjectId': draftSubjectId},
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (!mounted || selection == null) return;
    setState(() => _selectedSubjectId = selection['subjectId']);
  }

  Widget _buildMaterialCard(StudyMaterial material) {
    final subjectName = widget.subjects
        .where((subject) => subject.id == material.subjectId)
        .map((subject) => subject.name)
        .firstOrNull;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF3F7FE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFB5CCE8)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            material.type == StudyMaterialType.document
                ? Icons.description_outlined
                : Icons.link,
          ),
        ),
        title: Text(material.title),
        subtitle: Text(
          '${subjectName ?? 'Unknown subject'}\n'
          '${_typeLabel(material)} · Added ${_formatDate(material.addedAt)}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: 'Remove material',
          onPressed: () => _deleteMaterial(material),
          icon: const Icon(Icons.delete_outline),
        ),
        onTap: () => _showMaterialDetails(material),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasFilter = _searchQuery.isNotEmpty || _selectedSubjectId != null;
    return Center(
      child: Text(
        hasFilter
            ? 'No materials found.'
            : 'No materials yet. Tap + to add one.',
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  Future<void> _addMaterial() async {
    final material = await Navigator.push<StudyMaterial>(
      context,
      MaterialPageRoute<StudyMaterial>(
        builder: (_) => AddMaterialScreen(subjects: widget.subjects),
      ),
    );

    if (!mounted || material == null) return;

    try {
      await widget.database.saveMaterial(material);
      if (!mounted) {
        if (material.type == StudyMaterialType.document) {
          await deleteStoredMaterial(material.resourceLocation);
        }
        return;
      }
      setState(() => _materials.add(material));
    } catch (_) {
      if (material.type == StudyMaterialType.document) {
        await deleteStoredMaterial(material.resourceLocation);
      }
      _showMessage('Could not save the material. Try again.');
    }
  }

  Future<void> _showMaterialDetails(StudyMaterial material) async {
    final subjectName = widget.subjects
        .where((subject) => subject.id == material.subjectId)
        .map((subject) => subject.name)
        .firstOrNull;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ResourceDetailsScreen(
          material: material,
          subjectName: subjectName ?? 'Unknown subject',
        ),
      ),
    );
  }

  Future<void> _deleteMaterial(StudyMaterial material) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Material?'),
        content: Text('Remove "${material.title}" from your materials?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    try {
      await widget.database.deleteMaterial(material.id);
      if (material.type == StudyMaterialType.document) {
        await deleteStoredMaterial(material.resourceLocation);
      }
      if (!mounted) return;
      setState(() => _materials.removeWhere((item) => item.id == material.id));
    } catch (_) {
      _showMessage('Could not remove the material. Try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _typeLabel(StudyMaterial material) {
    if (material.type == StudyMaterialType.link) return 'Resource link';
    final fileName = material.fileName;
    final extension = fileName != null && fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'Document';
    return '$extension document';
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';
}
