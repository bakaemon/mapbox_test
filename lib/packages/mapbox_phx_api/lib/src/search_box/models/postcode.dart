import 'package:json_annotation/json_annotation.dart';

part 'postcode.g.dart';

@JsonSerializable(explicitToJson: true)
class Postcode {
  final String id;
  final String name;

  Postcode({
    required this.id,
    required this.name,
  });

  factory Postcode.fromJson(Map<String, dynamic> json) =>
      _$PostcodeFromJson(json);

  Map<String, dynamic> toJson() => _$PostcodeToJson(this);
}