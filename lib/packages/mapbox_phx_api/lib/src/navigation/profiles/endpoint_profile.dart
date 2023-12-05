import '../../../mapbox_phx_api.dart';
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


