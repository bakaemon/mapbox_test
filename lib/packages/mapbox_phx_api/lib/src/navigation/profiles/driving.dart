import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_phx_api/mapbox_phx_api.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import 'endpoint_profile.dart';

class DrivingProfile extends EndpointProfile {
  DrivingProfile({
    super.apiKey,
    super.drivingOptions,
  });

  final _baseUri =
      Uri.parse('https://api.mapbox.com/directions/v5/mapbox/driving/');

  Future<Map<String, dynamic>> routeCoordinate(
      List<mapbox.Position> stops) async {
    final response = await _directionRoute(stops);
    if (response.statusCode != 200) {
      throw Exception('Failed to load route: ${response.body}');
    }
    Map<String, dynamic> route = jsonDecode(response.body);
    return route['routes'][0];
  }

  Future<http.Response> _directionRoute(List<mapbox.Position> stops) async {
    // final uri = Uri.parse(
    //     "$_endpoint${start.last},${start.first};${end.last},${end.first}?overview=full&access_token=$accessToken");
    final uri = Uri(
      scheme: _baseUri.scheme,
      host: _baseUri.host,
      path: _baseUri.path + _buildCoordinateString(stops),
      queryParameters: {
        'access_token': apiKey!,
        if (drivingOptions?.geometry != null)
          'geometries': drivingOptions!.geometry.toString().split('.').last,
        if (drivingOptions?.overview != null)
          'overview': drivingOptions!.overview.toString().split('.').last,
        if (drivingOptions?.steps != null)
          'steps': drivingOptions!.steps.toString(),
        if (drivingOptions?.continueStraight != null)
          'continue_straight': drivingOptions!.continueStraight.toString(),
        if (drivingOptions?.roundTrip != null)
          'roundtrip': drivingOptions!.roundTrip.toString(),
        if (drivingOptions?.alternatives != null)
          'alternatives': drivingOptions!.alternatives.toString(),
        if (drivingOptions?.annotations != null)
          'annotations': drivingOptions!.annotations!
              .map((e) => e.toString().split('.').last)
              .join(','),
        if (drivingOptions?.source != null) 'source': drivingOptions!.source,
        if (drivingOptions?.destination != null)
          'destination': drivingOptions!.destination,
        if (drivingOptions?.exclude != null)
          'exclude':
              drivingOptions!.exclude!.map((e) => e.value).toList().join(','),
      },
    );
    return http.get(uri);
  }

  static String _buildCoordinateString(List<mapbox.Position> coordinates) {
    return coordinates.map((coord) => '${coord.lng},${coord.lat}').join(';');
  }
}
