import 'package:mapbox_phx_api/mapbox_phx_api.dart';
import 'package:mapbox_phx_api/src/profile.dart';
import 'package:mapbox_phx_api/src/search_box/profiles/profiles.dart';
import 'package:uuid/uuid.dart';

import '../api.dart';
import 'profiles/endpoint_profile.dart';
export 'profiles/profiles.dart';

class SearchBox implements EndpointAPI {
  SearchBox({
    String? apiKey,
  })  : assert(
          apiKey != null || MapBoxPHX.apiKey != null,
          'The API Key must be provided',
        ),
        _apiKey = apiKey ?? MapBoxPHX.apiKey!,
        sessionToken = const Uuid().v4();

  /// API Key of the MapBox.
  /// If not provided here then it must be provided [MapBoxSearch()] constructor
  final String _apiKey;

  final String sessionToken;

  /// Get the profiles of the API.
  /// Currently supports [SuggestProfile], [RetrieveProfile].
  @override
  T profile<T extends EndpointProfileInterface>() {
    switch (T) {
      case SuggestProfile:
        return SuggestProfile(
          apiKey: _apiKey,
          sessionToken: sessionToken,
        ) as T;
      case RetrieveProfile:
        return RetrieveProfile(
          apiKey: _apiKey,
          sessionToken: sessionToken,
        ) as T;
      default:
        throw Exception('Invalid profile type');
    }
  }
}
