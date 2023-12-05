import 'package:mapbox_geocode/mapbox_geocode.dart';

export 'profiles/profiles.dart';

class DrivingAPI {
  DrivingAPI({
    String? apiKey,
    this.drivingOptions,
  })  : assert(
          apiKey != null || MapBoxSearch.apiKey != null,
          'The API Key must be provided',
        ),
        _apiKey = apiKey ?? MapBoxSearch.apiKey!;

  /// API Key of the MapBox.
  /// If not provided here then it must be provided [MapBoxSearch()] constructor
  final String _apiKey;

  /// Driving options
  /// See [DrivingRouteOptions] for more details
  final DrivingRouteOptions? drivingOptions;

  /// get the profiles of the driving API.
  /// Currently supports [DrivingProfile], [OptimizationProfile].
  T profile<T extends EndpointProfile>({DrivingRouteOptions? options}) {
    if (T == DrivingProfile) {
      return DrivingProfile(
        apiKey: _apiKey,
        drivingOptions: options ?? drivingOptions,
      ) as T;
    } else if (T == OptimizationProfile) {
      return OptimizationProfile(
        apiKey: _apiKey,
        drivingOptions: options ?? drivingOptions,
      ) as T;
    } else {
      throw Exception('Invalid profile type');
    }
  }
}
