import 'package:json_annotation/json_annotation.dart';

import 'location_context/location_context.dart';

part "suggestion_response.g.dart";

@JsonSerializable()
class SuggestionResponse {
  SuggestionResponse({
    this.suggestions,
    this.attribution,
    this.url,
  });

  final List<Suggestion?>? suggestions;
  final String? attribution;
  final String? url;

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionResponseToJson(this);
}

@JsonSerializable()
class Suggestion {
  Suggestion({
    this.name,
    this.namePreferred,
    this.mapboxId,
    this.featureType,
    this.address,
    this.fullAddress,
    this.placeFormatted,
    // this.context,
    this.language,
    this.maki,
    this.externalIds,
    this.poiCategory,
    this.poiCategoryIds,
    this.brand,
    this.brandId,
  });

  final String? name;
  final String? namePreferred;
  final String? mapboxId;
  final String? featureType;
  final String? address;
  final String? fullAddress;
  final String? placeFormatted;
  // final LocationContext? context;
  final String? language;
  final String? maki;
  final ExternalIds? externalIds;
  final List<String>? poiCategory;
  final List<String>? poiCategoryIds;
  final List<String>? brand;
  final List<String>? brandId;

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionToJson(this);
}

@JsonSerializable()
class ExternalIds {
  ExternalIds({
    this.foursquare,
    this.safegraph,
  });

  final String? foursquare;
  final String? safegraph;

  factory ExternalIds.fromJson(Map<String, dynamic> json) =>
      _$ExternalIdsFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalIdsToJson(this);
}