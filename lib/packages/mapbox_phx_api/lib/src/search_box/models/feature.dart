import 'package:json_annotation/json_annotation.dart';
import 'models.dart';

part 'feature.g.dart';

@JsonSerializable(explicitToJson: true)
class FeatureCollection {
  String type;
  List<Feature> features;
  String? attribution;
  String? url;

  FeatureCollection({required this.type, required this.features, this.attribution, this.url});

  factory FeatureCollection.fromJson(Map<String, dynamic> json) =>
      _$FeatureCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureCollectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Feature {
  String type;
  Geometry geometry;
  Properties? properties;

  Feature({required this.type, required this.geometry, this.properties});

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}