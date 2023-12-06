import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/ui/mapbox/util/location_utils.dart';

import '../../../generated_assets/assets.gen.dart';

extension CircleAnnotationUtils on CircleAnnotation {
  CircleAnnotation copyWith({
    Map<String?, Object?>? geometry,
    double? circleSortKey,
    double? circleBlur,
    int? circleColor,
    double? circleOpacity,
    double? circleRadius,
    int? circleStrokeColor,
    double? circleStrokeOpacity,
    double? circleStrokeWidth,
  }) =>
      CircleAnnotation(
        id: id,
        geometry: geometry ?? this.geometry,
        circleSortKey: circleSortKey ?? this.circleSortKey,
        circleBlur: circleBlur ?? this.circleBlur,
        circleColor: circleColor ?? this.circleColor,
        circleOpacity: circleOpacity ?? this.circleOpacity,
        circleRadius: circleRadius ?? this.circleRadius,
        circleStrokeColor: circleStrokeColor ?? this.circleStrokeColor,
        circleStrokeOpacity: circleStrokeOpacity ?? this.circleStrokeOpacity,
        circleStrokeWidth: circleStrokeWidth ?? this.circleStrokeWidth,
      );
}

extension PointAnnotationUtils on PointAnnotation {
  PointAnnotation copyWith({
    Map<String?, Object?>? geometry,
    Uint8List? image,
    IconAnchor? iconAnchor,
    String? iconImage,
    List<double?>? iconOffset,
    double? iconRotate,
    double? iconSize,
    double? symbolSortKey,
    TextAnchor? textAnchor,
    String? textField,
    TextJustify? textJustify,
    double? textLetterSpacing,
    double? textMaxWidth,
    List<double?>? textOffset,
    double? textRadialOffset,
    double? textRotate,
    double? textSize,
    TextTransform? textTransform,
    int? iconColor,
    double? iconHaloBlur,
    int? iconHaloColor,
    double? iconHaloWidth,
    double? iconOpacity,
    int? textColor,
    double? textHaloBlur,
    int? textHaloColor,
    double? textHaloWidth,
    double? textOpacity,
  }) =>
      PointAnnotation(
        id: id,
        geometry: geometry,
        image: image,
        iconAnchor: iconAnchor,
        iconImage: iconImage,
        iconOffset: iconOffset,
        iconRotate: iconRotate,
        iconSize: iconSize,
        symbolSortKey: symbolSortKey,
        textAnchor: textAnchor,
        textField: textField,
        textJustify: textJustify,
        textLetterSpacing: textLetterSpacing,
        textMaxWidth: textMaxWidth,
        textOffset: textOffset,
        textRadialOffset: textRadialOffset,
        textRotate: textRotate,
        textSize: textSize,
        textTransform: textTransform,
        iconColor: iconColor,
        iconHaloBlur: iconHaloBlur,
        iconHaloColor: iconHaloColor,
        iconHaloWidth: iconHaloWidth,
        iconOpacity: iconOpacity,
        textColor: textColor,
        textHaloBlur: textHaloBlur,
        textHaloColor: textHaloColor,
        textHaloWidth: textHaloWidth,
        textOpacity: textOpacity,
      );

  Position toPosition() {
    final geometry = this.geometry?['coordinates'] as List<dynamic>;
    return Position(geometry[0], geometry[1]);
  }
}

extension AnnotationManagerUtil on PointAnnotationManager {
  Future<PointAnnotation> addPinAnnotation(Point point) async {
    return create(
      PointAnnotationOptions(
        geometry: point.toJson(),
        image: (await rootBundle.load(Assets.images.bus.path))
            .buffer
            .asUint8List(),
        iconSize: 1.5,
      ),
    );
  }

  Future<PointAnnotation> addAnnotation({
    required Point point,
    String? image,
  }) async {
    return create(
      PointAnnotationOptions(
        geometry: point.toJson(),
        image: image != null
            ? (await rootBundle.load(image)).buffer.asUint8List()
            : null,
        iconSize: 1.5,
      ),
    );
  }
}

extension ListPointAnnotationUtil on List<PointAnnotation> {
  void addPoint(PointAnnotation point, {VoidCallback? onAdded}) {
    add(point);
    onAdded?.call();
  }
}
