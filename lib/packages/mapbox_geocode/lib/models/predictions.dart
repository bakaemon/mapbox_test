import 'package:json_annotation/json_annotation.dart';

import 'mapbox_place.dart';

part 'predictions.g.dart';

@JsonSerializable()
class Predictions {
  final String? type;
  final List<dynamic>? query;
  final List<MapBoxPlace> features;

  Predictions({
    this.type,
    this.query,
    this.features = const [],
  });

  factory Predictions.empty() => Predictions(
        type: '',
        query: [],
        features: [],
      );

  factory Predictions.fromJson(Map<String, dynamic> json) =>
      _$PredictionsFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionsToJson(this);
}