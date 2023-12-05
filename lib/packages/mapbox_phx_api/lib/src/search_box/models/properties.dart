import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'properties.g.dart';

@JsonSerializable(explicitToJson: true)
class Properties {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'mapbox_id')
  String mapboxId;
  @JsonKey(name: 'feature_type')
  String featureType;
  @JsonKey(name: 'place_formatted')
  String placeFormatted;
  @JsonKey(name: 'context')
  LocationContext context;
  @JsonKey(name: 'coordinates')
  Coordinate coordinates;
  @JsonKey(name: 'bbox')
  List<double> bbox;
  @JsonKey(name: 'language')
  String language;
  @JsonKey(name: 'maki')
  String maki;
  @JsonKey(name: 'external_ids')
  Map<String, dynamic> externalIds;
  @JsonKey(name: 'metadata')
  Map<String, dynamic> metadata;

  Properties(
    this.name,
    this.mapboxId,
    this.featureType,
    this.placeFormatted,
    this.context,
    this.coordinates,
    this.bbox,
    this.language,
    this.maki,
    this.externalIds,
    this.metadata,
  );

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}
