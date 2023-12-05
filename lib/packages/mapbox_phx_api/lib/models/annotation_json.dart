import 'package:json_annotation/json_annotation.dart';

import 'bbox.dart';
import 'location.dart';

class LocationConverter extends JsonConverter<Location, List<dynamic>> {
  const LocationConverter() : super();

  @override
  Location fromJson(List<dynamic> json) {
    // return (long: json[0] as double, lat: json[1] as double);
    return Location.fromList(json.cast<double>());
  }

  @override
  List<double> toJson(Location object) {
    return object.asList;
  }
}

class BBoxConverter extends JsonConverter<BBox, List<dynamic>> {
  const BBoxConverter() : super();

  @override
  BBox fromJson(List<dynamic> json) {
    return BBox(
      // min: (long: json[0], lat: json[1]),
      // max: (long: json[2], lat: json[3]),
      min: Location.fromList([json[0], json[1]]),
      max: Location.fromList([json[2], json[3]]),
    );
  }

  @override
  List<double> toJson(BBox object) {
    return object.asList;
  }
}

class OptionalLocationConverter
    extends JsonConverter<Location?, List<dynamic>?> {
  const OptionalLocationConverter() : super();

  @override
  Location? fromJson(List<dynamic>? json) {
    return json == null ? null : Location.fromList(json.cast<double>());
  }

  @override
  List<double>? toJson(Location? object) {
    return object?.asList;
  }
}
