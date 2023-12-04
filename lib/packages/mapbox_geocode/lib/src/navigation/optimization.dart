import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class OptimizationAPI {
  OptimizationAPI({
    String? apiKey,
  })  : assert(apiKey != null || MapBoxSearch.apiKey != null,
            'The API Key must be provided'),
        _apiKey = apiKey ?? MapBoxSearch.apiKey!;
  final Uri _apiBaseUrl =
      Uri.parse('https://api.mapbox.com/optimized-trips/v1/mapbox/driving/');
  final String? _apiKey; // Add your Mapbox API key here

  Future<Map<String, dynamic>> optimizedRoute(List<Position> coordinates) async {
    if (_apiKey!.isEmpty) {
      throw Exception(
          'Mapbox API key not set. Please set the apiKey property.');
    }

    final response = await http.get(_apiBaseUrl.replace(
      path: _apiBaseUrl.path + _buildCoordinateString(coordinates),
      queryParameters: {
        'access_token': _apiKey!,
        'geometries': 'geojson',
        'overview': 'full',
        'steps': 'true',
        'roundtrip': 'false',
        'source': 'first',
        'destination': 'last',
      },
    ));

    if (response.statusCode == 200) {
      Map<String, dynamic> route = jsonDecode(response.body);
      return route['trips'][0]['geometry'];
    } else {
      throw Exception('Failed to get optimized route: ${response.body}');
    }
  }

  static String _buildCoordinateString(List<Position> coordinates) {
    return coordinates.map((coord) => '${coord.lng},${coord.lat}').join(';');
  }
}
