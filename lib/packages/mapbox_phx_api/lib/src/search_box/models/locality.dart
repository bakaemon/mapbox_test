import 'package:json_annotation/json_annotation.dart';

part 'locality.g.dart';

@JsonSerializable(explicitToJson: true)
class Locality {
  final String id;
  final String name;

  Locality({
    required this.id,
    required this.name,
  });

  factory Locality.fromJson(Map<String, dynamic> json) =>
      _$LocalityFromJson(json);

  Map<String, dynamic> toJson() => _$LocalityToJson(this);
}