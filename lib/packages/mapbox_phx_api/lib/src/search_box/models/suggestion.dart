import 'package:json_annotation/json_annotation.dart';
import 'models.dart';
part 'suggestion.g.dart';

@JsonSerializable(explicitToJson: true)
class Suggestion {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'mapbox_id')
  final String mapboxId;
  @JsonKey(name: 'feature_type')
  final String featureType;
  @JsonKey(name: 'place_formatted')
  final String placeFormatted;
  @JsonKey(name: 'context')
  final LocationContext? context;
  @JsonKey(name: 'language')
  final String? language;
  @JsonKey(name: 'maki')
  final String? maki;
  @JsonKey(name: 'external_ids')
  final ExternalIds? externalIds;
  @JsonKey(name: 'metadata')
  final Metadata? metadata;

  Suggestion({
    required this.name,
    required this.mapboxId,
    required this.featureType,
    required this.placeFormatted,
    this.context,
    this.language,
    this.maki,
    this.externalIds,
    this.metadata,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionToJson(this);
}

@JsonSerializable()
class ExternalIds {
  ExternalIds();

  factory ExternalIds.fromJson(Map<String, dynamic> json) =>
      _$ExternalIdsFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
