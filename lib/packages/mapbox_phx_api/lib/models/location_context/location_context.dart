import 'package:json_annotation/json_annotation.dart';

import 'country.dart';

part 'location_context.g.dart';

@JsonSerializable(explicitToJson: true)
class LocationContext {
  LocationContext({
    this.country,
    // this.region,
    // this.postcode,
    // this.district,
    // this.place,
    // this.neighborhood,
    // this.street,
  });

  final Country? country;
  // final Region? region;
  // final Place? postcode;
  // final Place? district;
  // final Place? place;
  // final Neighborhood? neighborhood;
  // final Neighborhood? street;

  factory LocationContext.fromJson(Map<String, dynamic> json) =>
      _$LocationContextFromJson(json);

  Map<String, dynamic> toJson() => _$LocationContextToJson(this);
}

