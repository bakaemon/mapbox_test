
import 'package:json_annotation/json_annotation.dart';
import 'package:mapbox_geocode/models/location_context/location_context.dart';

import 'annotation_json.dart';
import 'bbox.dart';
import 'external_id.dart';
import 'feature.dart';
import 'location.dart';

part 'retrieve_response.g.dart';

@JsonSerializable()
class RetrieveResponse {
  RetrieveResponse({
    required this.type,
    required this.features,
    required this.attribution,
    required this.url,
  });

  final String type;
  final List<Feature> features;
  final String attribution;
  final String url;

  factory RetrieveResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RetrieveResponseToJson(this);
}


@JsonSerializable()
class RetrieveProperties {
  RetrieveProperties({
    this.name,
    this.mapboxId,
    this.featureType,
    this.address,
    this.fullAddress,
    this.placeFormatted,
    // this.context,
    this.coordinates,
    this.bbox,
    this.language,
    this.maki,
    this.externalIds,
    this.metadata,
  });

  final String? name;
  final String? mapboxId;
  final String? featureType;
  final String? address;
  final String? fullAddress;
  final String? placeFormatted;
  // final LocationContext? context;
  @LocationConverter()
  final Location? coordinates;
  @BBoxConverter()
  final BBox? bbox;
  final String? language;
  final String? maki;
  final ExternalIds? externalIds;
  final ExternalIds? metadata;

  factory RetrieveProperties.fromJson(Map<String, dynamic> json) =>
      _$RetrievePropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$RetrievePropertiesToJson(this);
}

// class Coordinates {
//   Coordinates({
//     required this.latitude,
//     required this.longitude,
//   });

//   final double latitude;
//   final double longitude;

//   factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "latitude": latitude,
//         "longitude": longitude,
//       };
// }