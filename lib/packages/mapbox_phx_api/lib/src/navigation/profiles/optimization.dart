import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_phx_api/mapbox_phx_api.dart';

import 'endpoint_profile.dart';



class OptimizationProfile extends EndpointProfile {
  OptimizationProfile({
    super.apiKey,
    super.drivingOptions,
  });

  final Uri _apiBaseUrl =
      Uri.parse('https://api.mapbox.com/optimized-trips/v1/mapbox/driving/');

  Future<Map<String, dynamic>> optimizedRoute(
      List<Position> coordinates) async {
    if (apiKey!.isEmpty) {
      throw Exception(
          'Mapbox API key not set. Please set the apiKey property.');
    }

    final response = await http.get(_apiBaseUrl.replace(
      path: _apiBaseUrl.path + _buildCoordinateString(coordinates),
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

        // 'roundtrip': 'false',
        // 'source': 'first',
        // 'destination': 'last',
      },
    ));

    if (response.statusCode == 200) {
      Map<String, dynamic> route = jsonDecode(response.body);
      return route['trips'][0];
    } else {
      throw Exception('Failed to get optimized route: ${response.body}');
    }
  }

  static String _buildCoordinateString(List<Position> coordinates) {
    return coordinates.map((coord) => '${coord.lng},${coord.lat}').join(';');
  }
}
