import '../../../mapbox_phx_api.dart';
import '../../profile.dart';

class EndpointProfile implements EndpointProfileInterface {
  EndpointProfile({
    String? apiKey,
    this.drivingOptions,
  })  : assert(apiKey != null || MapBoxPHX.apiKey != null,
            'The API Key must be provided'),
        apiKey = apiKey ?? MapBoxPHX.apiKey!;

  final String? apiKey;
  final DrivingRouteOptions? drivingOptions;
}
