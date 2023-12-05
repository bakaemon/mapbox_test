import 'package:json_annotation/json_annotation.dart';

import 'geometry.dart';

part 'feature.g.dart';

@JsonSerializable()
class Feature {
  Feature({
    this.type,
    this.geometry,
    // this.properties,
  });
  final String? type;
  final Geometry? geometry;
  // final Properties? properties;

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}

enum FeatureType {
  @JsonValue("Feature")
  FEATURE
}

enum GeometryType {
  @JsonValue("Point")
  POINT
}