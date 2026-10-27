import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/video_search_result.dart';

class YouTubeVideoSearchException implements Exception {
  final String message;
  const YouTubeVideoSearchException(this.message);

  @override
  String toString() => message;
}

class YouTubeVideoSearchService {
  static const _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  final http.Client _client;

  YouTubeVideoSearchService({http.Client? client})
    : _client = client ?? http.Client();

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<List<VideoSearchResult>> search(String query) async {
    if (!isConfigured) {
      throw const YouTubeVideoSearchException(
        'YouTube search is not configured. Provide YOUTUBE_API_KEY at build time.',
      );
    }

    final uri = Uri.https('www.googleapis.com', '/youtube/v3/search', {
      'part': 'snippet',
      'type': 'video',
      'maxResults': '15',
      'q': '$query educational',
      'key': _apiKey,
    });
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        final apiMessage = (body['error'] as Map<String, dynamic>?)?['message'];
        throw YouTubeVideoSearchException(
          apiMessage is String
              ? apiMessage
              : 'YouTube search failed. Try again.',
        );
      }
      final items = body['items'] as List<dynamic>? ?? const [];
      return items
          .whereType<Map<String, dynamic>>()
          .map(VideoSearchResult.fromJson)
          .toList();
    } on YouTubeVideoSearchException {
      rethrow;
    } on Exception {
      throw const YouTubeVideoSearchException(
        'Could not reach YouTube. Check your connection and try again.',
      );
    }
  }
}
