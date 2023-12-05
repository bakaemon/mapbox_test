import 'package:json_annotation/json_annotation.dart';

part 'properties.g.dart';

// enum GeometryType {
//   @JsonValue("Point")
//   POINT
// }


@JsonSerializable()
class Properties {
  String? shortCode;
  String? wikidata;
  String? address;

  Properties({
    this.shortCode,
    this.wikidata,
    this.address,
  });

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}

