import '../../../mapbox_phx_api.dart';
import '../../profile.dart';

class EndpointProfile implements EndpointProfileInterface {
  EndpointProfile({
    String? apiKey,
    this.sessionToken,
  })  : assert(apiKey != null || MapBoxPHX.apiKey != null,
            'The API Key must be provided'),
        apiKey = apiKey ?? MapBoxPHX.apiKey!;

  final String? apiKey;
  final String? sessionToken;
}


