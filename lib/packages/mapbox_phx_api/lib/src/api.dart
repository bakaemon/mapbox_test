import 'package:mapbox_phx_api/src/profile.dart';

abstract class EndpointAPI {
  T profile<T extends EndpointProfileInterface>();
}