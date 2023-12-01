import 'package:json_annotation/json_annotation.dart';

part 'region.g.dart';

@JsonSerializable(explicitToJson: true)
class Region {
  Region({
    this.id,
    this.name,
    this.regionCode,
    this.regionCodeFull,
  });

  final String? id;
  final String? name;
  final String? regionCode;
  final String? regionCodeFull;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

