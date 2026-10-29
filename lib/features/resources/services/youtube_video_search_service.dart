import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/video_search_result.dart';

class YouTubeVideoSearchException implements Exception {
  final String message;
  const YouTubeVideoSearchException(this.message);

  @override
  String toString() => message;
}

class YouTubeVideoSearchService {
  static const _workerUrl = String.fromEnvironment(
    'YOUTUBE_SEARCH_WORKER_URL',
  );
  final http.Client _client;

  YouTubeVideoSearchService({http.Client? client})
    : _client = client ?? http.Client();

  bool get isConfigured => _workerUrl.isNotEmpty;

  Future<List<VideoSearchResult>> search(String query) async {
    if (!isConfigured) {
      throw const YouTubeVideoSearchException(
        'YouTube search is not configured. Provide YOUTUBE_SEARCH_WORKER_URL at build time.',
      );
    }

    final workerUri = Uri.tryParse(_workerUrl);
    if (workerUri == null ||
        workerUri.scheme != 'https' ||
        workerUri.host.isEmpty) {
      throw const YouTubeVideoSearchException(
        'YouTube search Worker URL is invalid. Provide its HTTPS URL.',
      );
    }

    final uri = workerUri.replace(
      path: '${workerUri.path.replaceFirst(RegExp(r'/$'), '')}/search',
      queryParameters: {'q': query.trim()},
    );
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
