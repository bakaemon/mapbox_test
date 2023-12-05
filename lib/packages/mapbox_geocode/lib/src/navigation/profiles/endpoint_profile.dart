import 'package:mapbox_geocode/mapbox_geocode.dart';

import 'driving_route_options.dart';

class EndpointProfile {
  EndpointProfile({
    String? apiKey,
    this.drivingOptions,
  })  : assert(apiKey != null || MapBoxSearch.apiKey != null,
            'The API Key must be provided'),
        apiKey = apiKey ?? MapBoxSearch.apiKey!;

  final String? apiKey;
  final DrivingRouteOptions? drivingOptions;
}


