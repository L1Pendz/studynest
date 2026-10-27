import 'package:flutter/material.dart';

import '../models/video_search_result.dart';

class VideoSearchSection extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final List<VideoSearchResult> videos;
  final bool isSearching;
  final String? error;
  final ValueChanged<String> onSearch;
  final ValueChanged<VideoSearchResult> onOpen;
  final ValueChanged<VideoSearchResult> onSave;
  final bool Function(VideoSearchResult) isSaved;

  const VideoSearchSection({
    super.key,
    required this.controller,
    required this.query,
    required this.videos,
    required this.isSearching,
    required this.error,
    required this.onSearch,
    required this.onOpen,
    required this.onSave,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: onSearch,
            decoration: InputDecoration(
              hintText: 'Search YouTube for educational videos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Search videos',
                onPressed: () => onSearch(controller.text),
                icon: const Icon(Icons.arrow_forward),
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
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => onSearch(query),
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }
    if (query.isEmpty || videos.isEmpty) {
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
                query.isEmpty
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
      itemCount: videos.length,
      itemBuilder: (context, index) => _buildVideoCard(videos[index]),
    );
  }

  Widget _buildVideoCard(VideoSearchResult video) {
    final saved = isSaved(video);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF3F7FE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFB5CCE8)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onOpen(video),
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
              IconButton(
                tooltip: saved
                    ? 'Saved to My Materials'
                    : 'Save to My Materials',
                onPressed: () => onSave(video),
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_add_outlined,
                  color: saved ? Colors.indigo : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.month}/${date.day}/${date.year}';
}
