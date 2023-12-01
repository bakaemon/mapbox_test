import 'package:json_annotation/json_annotation.dart';

import '../mapbox_geocode.dart';
import 'annotation_json.dart';
import 'feature.dart';
import 'geometry.dart';
import 'properties.dart';

part 'mapbox_place.g.dart';

@JsonSerializable()
class MapBoxPlace {
  final String? id;
  final FeatureType? type;
  final List<PlaceType?> placeType;

  // dynamic relevance;
  final String? addressNumber;
  final Properties? properties;
  final String? text;
  final String? placeName;
  @BBoxConverter()
  final BBox? bbox;
  @OptionalLocationConverter()
  final Location? center;
  final Geometry? geometry;
  // final List<Context>? context;
  final String? matchingText;
  final String? matchingPlaceName;

  MapBoxPlace({
    this.id,
    this.type,
    this.placeType = const [],
    // this.relevance,
    this.addressNumber,
    this.properties,
    this.text,
    this.placeName,
    this.bbox,
    this.center,
    this.geometry,
    // this.context,
    this.matchingText,
    this.matchingPlaceName,
  });

  factory MapBoxPlace.fromJson(Map<String, dynamic> json) =>
      _$MapBoxPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$MapBoxPlaceToJson(this);

  @override
  String toString() => text ?? placeName!;
}
