import 'location.dart';

class BBox {
  final Location min;
  final Location max;

  BBox({
    required this.min,
    required this.max,
  });

  String get asString => '${min.asString},${max.asString}';

  List<double> get asList => [
        ...min.asList,
        ...max.asList,
      ];

  factory BBox.fromList(List<double> list) => BBox(
        min: Location.fromList(list),
        max: Location.fromList(list.sublist(2)),
      );
}
