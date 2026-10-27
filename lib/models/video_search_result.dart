class VideoSearchResult {
  final String videoId;
  final String title;
  final String channelTitle;
  final String thumbnailUrl;
  final DateTime? publishedAt;

  const VideoSearchResult({
    required this.videoId,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.publishedAt,
  });

  factory VideoSearchResult.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as Map<String, dynamic>?;
    final snippet = json['snippet'] as Map<String, dynamic>?;
    final thumbnails = snippet?['thumbnails'] as Map<String, dynamic>?;
    final thumbnail =
        (thumbnails?['high'] ?? thumbnails?['medium'] ?? thumbnails?['default'])
            as Map<String, dynamic>?;
    final videoId = id?['videoId'] as String?;
    if (videoId == null || snippet == null) {
      throw const FormatException('Invalid video result');
    }
    return VideoSearchResult(
      videoId: videoId,
      title: (snippet['title'] as String?) ?? 'Untitled video',
      channelTitle: (snippet['channelTitle'] as String?) ?? 'Unknown channel',
      thumbnailUrl: (thumbnail?['url'] as String?) ?? '',
      publishedAt: DateTime.tryParse(snippet['publishedAt'] as String? ?? ''),
    );
  }

  Uri get watchUrl => Uri.https('www.youtube.com', '/watch', {'v': videoId});
}
