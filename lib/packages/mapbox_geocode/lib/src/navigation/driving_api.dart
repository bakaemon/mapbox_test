import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

enum Overview { full, simplified, false_ }

class DrivingAPI {
  DrivingAPI({
    String? apiKey,
    this.overview = Overview.full,
  })  : assert(
          apiKey != null || MapBoxSearch.apiKey != null,
          'The API Key must be provided',
        ),
        _apiKey = apiKey ?? MapBoxSearch.apiKey!;

  /// API Key of the MapBox.
  /// If not provided here then it must be provided [MapBoxSearch()] constructor
  final String _apiKey;

  /// Specify the maximum number of results to return. The default is 5 and the maximum supported is 10.
  final Overview? overview;

  final _baseUri =
      Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/');

  Future<String> routeCoordinatePolygon(
      mapbox.Position start, mapbox.Position end) async {
    final response = await _directionRoute(start, end);
    if (response.statusCode != 200) {
      throw Exception('Failed to load route: ${response.body}');
    }
    Map<String, dynamic> route = jsonDecode(response.body);
    return route['routes'][0]['geometry'];
  }

  Future<http.Response> _directionRoute(
      mapbox.Position start, mapbox.Position end) async {
    // final uri = Uri.parse(
    //     "$_endpoint${start.last},${start.first};${end.last},${end.first}?overview=full&access_token=$accessToken");
    final uri = Uri(
      scheme: _baseUri.scheme,
      host: _baseUri.host,
      path:
          'directions/v5/mapbox/driving/${start.lng},${start.lat};${end.lng},${end.lat}',
      queryParameters: {
        'overview': overview.toString().split('.').last,
        'access_token': _apiKey,
      },
    );
    return http.get(uri);
  }
}


