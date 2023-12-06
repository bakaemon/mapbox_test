import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'geometry.g.dart';

@JsonSerializable(explicitToJson: true)
class Geometry {
  List<num> coordinates;

  Geometry(this.coordinates);

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}
