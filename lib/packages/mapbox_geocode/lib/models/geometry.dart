import 'package:json_annotation/json_annotation.dart';

import 'annotation_json.dart';
import 'location.dart';

part 'geometry.g.dart';

@JsonSerializable()
class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  final String? type;
  @LocationConverter()
  final Location? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}
