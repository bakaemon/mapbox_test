import 'package:json_annotation/json_annotation.dart';

part 'neighborhood.g.dart';

@JsonSerializable(explicitToJson: true)
class Neighborhood {
  Neighborhood({
    this.name,
  });

  final String? name;

  factory Neighborhood.fromJson(Map<String, dynamic> json) =>
      _$NeighborhoodFromJson(json);

  Map<String, dynamic> toJson() => _$NeighborhoodToJson(this);
}

