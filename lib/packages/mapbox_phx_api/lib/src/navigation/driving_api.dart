

import 'package:mapbox_phx_api/src/profile.dart';

import '../../mapbox_phx_api.dart';
import '../api.dart';
export 'profiles/profiles.dart';

class Direction implements EndpointAPI {
  Direction({
    String? apiKey,
    this.drivingOptions,
  })  : assert(
          apiKey != null || MapBoxPHX.apiKey != null,
          'The API Key must be provided',
        ),
        _apiKey = apiKey ?? MapBoxPHX.apiKey!;

  /// API Key of the MapBox.
  /// If not provided here then it must be provided [MapBoxSearch()] constructor
  final String _apiKey;

  /// Driving options
  /// See [DrivingRouteOptions] for more details
  final DrivingRouteOptions? drivingOptions;

  /// get the profiles of the driving API.
  /// Currently supports [DrivingProfile], [OptimizationProfile].
  @override
  T profile<T extends EndpointProfileInterface>({DrivingRouteOptions? options}) {
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
