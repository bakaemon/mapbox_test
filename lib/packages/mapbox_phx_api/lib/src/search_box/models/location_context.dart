import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'location_context.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationContext {
  final Country? country;
  final Postcode? postcode;
  final Place? place;
  final Locality? locality;

  LocationContext({
    this.country,
    this.postcode,
    this.place,
    this.locality,
  });

  factory LocationContext.fromJson(Map<String, dynamic> json) =>
      _$LocationContextFromJson(json);

  Map<String, dynamic> toJson() => _$LocationContextToJson(this);
}
