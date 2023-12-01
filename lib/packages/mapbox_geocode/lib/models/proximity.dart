import 'location.dart';

class Proximity {
  factory Proximity.locationNone() => const NoProximity();
  factory Proximity.locationIp() => const IpProximity();
  factory Proximity.location(Location loc) => LocationProximity(loc: loc);
  factory Proximity.latLong({required double lat, required double long}) =>
      LocationProximity(loc: Location(lat: lat, long: long));
}

/// A class that represents a location around which places will be searched.
class LocationProximity implements Proximity {
  final Location loc;

  const LocationProximity({
    required this.loc,
  });

  String get asString => loc.asString;
}

/// A class that represents that no location based search will be performed.
class NoProximity implements Proximity {
  const NoProximity();
}

/// A class that represents that the location will be based on the IP address of the user.
class IpProximity implements Proximity {
  const IpProximity();
}
