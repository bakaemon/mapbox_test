class DrivingRouteOptions {
  DrivingRouteOptions({
    this.overview = Overview.full,
    this.geometry = GeometryResponseType.geojson,
    this.steps,
    this.continueStraight,
    this.roundTrip,
    this.alternatives,
    this.annotations,
    this.source,
    this.destination,
    this.exclude,
  });

  final Overview? overview;
  final GeometryResponseType? geometry;
  final bool? steps;
  final bool? continueStraight;
  final bool? roundTrip;
  final bool? alternatives;
  final List<DrivingAnnotations>? annotations;
  final String? source;
  final String? destination;
  final List<DrivingExcludes>? exclude;
}

enum Overview { full, simplified }

enum GeometryResponseType { geojson, polyline, polyline6 }

enum DrivingAnnotations {
  duration,
  distance,
  speed,
  congestion,
  congestionNumeric,
  maxspeed,
  closure,
}

enum DrivingExcludes {
  tolls,
  motorways,
  ferry,
  unpaved,
  cashOnlyTolls,
}

extension DrivingExcludeUtils on DrivingExcludes {
  String get value {
    switch (this) {
      case DrivingExcludes.tolls:
        return 'tolls';
      case DrivingExcludes.motorways:
        return 'motorways';
      case DrivingExcludes.ferry:
        return 'ferry';
      case DrivingExcludes.unpaved:
        return 'unpaved';
      case DrivingExcludes.cashOnlyTolls:
        return 'cash_only_tolls';
      default:
        return '';
    }
  }
}

extension DrivingAnnotationUtils on DrivingAnnotations {
  String get value {
    switch (this) {
      case DrivingAnnotations.duration:
        return 'duration';
      case DrivingAnnotations.distance:
        return 'distance';
      case DrivingAnnotations.speed:
        return 'speed';
      case DrivingAnnotations.congestion:
        return 'congestion';
      case DrivingAnnotations.congestionNumeric:
        return 'congestion_numeric';
      case DrivingAnnotations.maxspeed:
        return 'maxspeed';
      case DrivingAnnotations.closure:
        return 'closure';
      default:
        return '';
    }
  }
}
