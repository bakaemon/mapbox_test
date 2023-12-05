import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_id.g.dart';

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