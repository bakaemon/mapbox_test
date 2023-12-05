import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true)
class Country {
  final String? id;
  final String? name;
  @JsonKey(name: 'country_code')
  final String? countryCode;
  @JsonKey(name: 'country_code_alpha_3')
  final String? countryCodeAlpha3;

  Country({
    this.id,
    this.name,
    this.countryCode,
    this.countryCodeAlpha3,
  });

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}