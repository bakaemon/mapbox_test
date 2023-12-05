import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/models.dart';

import 'endpoint_profile.dart';

class SuggestProfile extends EndpointProfile {
  SuggestProfile({
    super.apiKey,
    super.sessionToken,
  });

  final String _baseUri = 'https://api.mapbox.com/search/searchbox/v1/suggest';

  Future<List<Suggestion>> searchSuggestions({
    required String query,
    String language = 'en',
    String country = 'vn',
  }) async {
    final response = await _requestSearchSuggestions(query, language, country);

    if (response.statusCode != 200) {
      throw Exception('Failed to load search suggestions: ${response.body}');
    }

    List<dynamic> suggestions = jsonDecode(response.body)['suggestions'];
    return suggestions.map((e) => Suggestion.fromJson(e)).toList();
  }

  Future<http.Response> _requestSearchSuggestions(
      String query, String language, String country) async {
    // final uri = Uri.parse(
    //     '$_baseUri?q=$query&language=$language&country=$country&access_token=$apiKey');
    final uri = Uri(
      scheme: Uri.parse(_baseUri).scheme,
      host: Uri.parse(_baseUri).host,
      path: Uri.parse(_baseUri).path,
      queryParameters: {
        'q': query,
        'language': language,
        'country': country,
        'access_token': apiKey!,
        'session_token': sessionToken,
      },
    );
    return http.get(uri);
  }
}
