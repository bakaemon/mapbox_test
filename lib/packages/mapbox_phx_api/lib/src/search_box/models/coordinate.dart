import 'package:json_annotation/json_annotation.dart';

part 'coordinate.g.dart';
@JsonSerializable(explicitToJson: true)
class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);

  factory Coordinate.fromJson(Map<String, dynamic> json) =>
      _$CoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinateToJson(this);
}
