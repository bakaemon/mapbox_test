import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'endpoint_profile.dart';

class RetrieveProfile extends EndpointProfile {
  RetrieveProfile({
    super.apiKey,
    super.sessionToken,
  });

  final Uri _baseUri =
      Uri.parse('https://api.mapbox.com/search/searchbox/v1/retrieve/');

  Future<FeatureCollection> retrieveResult({
    required String mapboxId,
  }) async {
    final uri = _baseUri.replace(
      path: _baseUri.path + mapboxId,
      queryParameters: {
        'access_token': apiKey!,
      },
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load retrieve result: ${response.body}');
    }

    return FeatureCollection.fromJson(jsonDecode(response.body));
  }
}
