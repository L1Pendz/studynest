import 'package:flutter/material.dart';
import 'package:studynest/utils/subject_lookup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/app_database.dart';
import '../../../models/subject.dart';
import '../data/material_file_storage.dart';
import '../models/study_material.dart';
import '../models/video_search_result.dart';
import '../services/youtube_video_search_service.dart';
import '../widgets/my_materials_section.dart';
import '../widgets/resource_filter_sheet.dart';
import '../widgets/video_search_section.dart';
import 'resource_details_screen.dart';
import 'resource_form_screen.dart';

class ResourcesScreen extends StatefulWidget {
  final AppDatabase database;
  final List<Subject> subjects;
  final List<StudyMaterial> initialMaterials;
  final String? requestedSubjectId;
  final int subjectNavigationRequest;
  final bool requestedVideoSearch;

  const ResourcesScreen({
    super.key,
    required this.database,
    required this.subjects,
    required this.initialMaterials,
    this.requestedSubjectId,
    this.subjectNavigationRequest = 0,
    this.requestedVideoSearch = false,
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
    if (oldWidget.subjectNavigationRequest != widget.subjectNavigationRequest) {
      _showVideos = widget.requestedVideoSearch;
      _selectedSubjectId = widget.requestedVideoSearch
          ? null
          : widget.requestedSubjectId;
      if (widget.requestedVideoSearch) {
        _videoQuery = '';
        _videos = [];
        _videoError = null;
        _videoSearchController.text =
            findSubjectById(widget.subjects, widget.requestedSubjectId)?.name ??
            '';
      }
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
              Expanded(
                child: VideoSearchSection(
                  controller: _videoSearchController,
                  query: _videoQuery,
                  videos: _videos,
                  isSearching: _isSearchingVideos,
                  error: _videoError,
                  onSearch: _searchVideos,
                  onOpen: _openVideo,
                  onSave: _saveVideo,
                  isSaved: _isVideoSaved,
                ),
              ),
            ] else ...[
              Expanded(
                child: MyMaterialsSection(
                  materials: materials,
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  hasFilters:
                      _searchQuery.isNotEmpty || _selectedSubjectId != null,
                  filterIsActive: _selectedSubjectId != null,
                  onSearchChanged: (value) =>
                      setState(() => _searchQuery = value.trim()),
                  onClearSearch: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  onShowFilter: _showFilterSheet,
                  itemBuilder: (context, index) =>
                      _buildMaterialCard(materials[index]),
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

  Future<void> _showFilterSheet() async {
    final selection = await showModalBottomSheet<Map<String, String?>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ResourceFilterSheet(
        subjects: widget.subjects,
        selectedSubjectId: _selectedSubjectId,
      ),
    );

    if (!mounted || selection == null) return;
    setState(() => _selectedSubjectId = selection['subjectId']);
  }

  bool _isVideoSaved(VideoSearchResult video) {
    return _materials.any(
      (material) =>
          material.type == StudyMaterialType.link &&
          material.resourceLocation == video.watchUrl.toString(),
    );
  }

  Future<void> _saveVideo(VideoSearchResult video) async {
    if (_isVideoSaved(video)) {
      _showMessage('This video is already in My Materials.');
      return;
    }

    final material = StudyMaterial(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: video.title,
      subjectId: Subject.noSubjectId,
      description: 'YouTube video by ${video.channelTitle}',
      type: StudyMaterialType.link,
      resourceLocation: video.watchUrl.toString(),
      addedAt: DateTime.now(),
    );

    try {
      await widget.database.saveMaterial(material);
      if (!mounted) return;
      setState(() => _materials.add(material));
      _showMessage('Saved to My Materials.');
    } catch (_) {
      _showMessage('Could not save this video. Try again.');
    }
  }

  Widget _buildMaterialCard(StudyMaterial material) {
    final subjectName = findSubjectById(
      widget.subjects,
      material.subjectId,
    )?.name;

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
        onTap: () => _showMaterialDetails(material),
      ),
    );
  }

  Future<void> _addMaterial() async {
    final material = await Navigator.push<StudyMaterial>(
      context,
      MaterialPageRoute<StudyMaterial>(
        builder: (_) => ResourceFormScreen(subjects: widget.subjects),
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
    final subjectName = findSubjectById(
      widget.subjects,
      material.subjectId,
    )?.name;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ResourceDetailsScreen(
          material: material,
          subjectName: subjectName ?? 'Unknown subject',
          subjects: widget.subjects,
          database: widget.database,
          onMaterialUpdated: (updated) {
            if (!mounted) return;
            setState(() {
              final index = _materials.indexWhere(
                (item) => item.id == updated.id,
              );
              if (index != -1) _materials[index] = updated;
            });
          },
          onDelete: () async {
            await widget.database.deleteMaterial(material.id);
            if (material.type == StudyMaterialType.document) {
              await deleteStoredMaterial(material.resourceLocation);
            }
            if (!mounted) return;
            setState(() {
              _materials.removeWhere((item) => item.id == material.id);
            });
          },
        ),
      ),
    );
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
