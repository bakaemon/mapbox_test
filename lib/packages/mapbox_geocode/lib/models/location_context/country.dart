import 'package:json_annotation/json_annotation.dart';
part 'country.g.dart'; 
@JsonSerializable(explicitToJson: true)
class Country {
  Country({
    this.id,
    this.name,
    this.countryCode,
    this.countryCodeAlpha3,
  });

  final String? id;
  final String? name;
  final String? countryCode;
  @JsonKey(name: "country_code_alpha_3")
  final String? countryCodeAlpha3;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

