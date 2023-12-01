


class Location {
  final double long;
  final double lat;

  const Location({
    required this.long,
    required this.lat,
  });

  factory Location.fromList(List<double> latLng) => Location(
        long: latLng[0],
        lat: latLng[1],
      );

  /// Returns a list of the [long] and [lat] values. Values are in that order.
  List<double> get asList => [long, lat];

  @override
  String toString() => 'Location(long: $long, lat: $lat)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Location && other.long == long && other.lat == lat;
  }

  @override
  int get hashCode => long.hashCode ^ lat.hashCode;

  String get asString => '$long,$lat';
}

