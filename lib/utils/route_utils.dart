import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:mapbox_test/token.dart';
import 'package:mapbox_test/utils/location_utils.dart';
import 'package:turf/polyline.dart';

enum RouteType { line, animated }

class RouteUtil {
  RouteUtil._(this.mapState)
      : assert(mapState.mapboxMap != null, "mapboxMap must not be null") {
    mapboxMap = mapState.mapboxMap;
    mapboxMap?.style.styleSourceExists("source").then((hasStyleSource) async {
      if (hasStyleSource) {
        await mapboxMap!.style.removeStyleLayer("layer");
        await mapboxMap!.style.removeStyleSource("source");
      }
    });
  }

  dynamic mapState;

  MapboxMap? mapboxMap;

  Animation<double>? animation;
  AnimationController? controller;

  /// Create a [RouteUtil] from a [State] with [TickerProviderStateMixin].
  /// The [State] must have field `mapboxMap`
  /// of type [MapboxMap] containing the map.
  factory RouteUtil.of(dynamic mapState) => RouteUtil._(mapState);

  /// Draw a route from current location to a given [Position]
  void drawFromCurrentTo(Position position) async {
    final start = await mapboxMap!.style.getPuckPosition();
    drawRoute(start, position);
  }

  /// Draw a route from given [Position] objects.
  void drawRoute(
    Position start,
    Position end, {
    RouteType routeType = RouteType.line,
  }) async {
    _drawRoute(await _fetchRouteCoordinates(start, end),
        routeType: RouteType.animated);
  }

  Future<void> _drawRoute(List<Position> polyline,
      {RouteType routeType = RouteType.line}) async {
    switch (routeType) {
      case RouteType.line:
        _drawLineRoute(polyline);
        break;
      case RouteType.animated:
        _drawRouteAnimated(polyline);
        break;
    }
  }

  /// Draw a line route from given [Position] objects.
  void _drawLineRoute(List<Position> polyline) async {
    final line = LineString(coordinates: polyline);
    mapboxMap?.style.styleSourceExists("source").then((exists) async {
      if (exists) {
        // if source exists - just update it
        final source = await mapboxMap!.style.getSource("source");
        (source as GeoJsonSource).updateGeoJSON(json.encode(line));
      } else {
        await mapboxMap!.style.addSource(GeoJsonSource(
            id: "source", data: json.encode(line), lineMetrics: true));

        await mapboxMap!.style.addLayer(LineLayer(
          id: 'layer',
          sourceId: 'source',
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
          lineColor: Colors.deepOrangeAccent.value,
          lineBlur: 1.0,
          lineWidth: 5.0,
        ));
      }
    });
  }

  /// Draw animated route from given [Position] objects.
  void _drawRouteAnimated(List<Position> polyline) async {
    final line = LineString(coordinates: polyline);
    mapboxMap?.style.styleSourceExists("source").then((exists) async {
      if (exists) {
        // if source exists - just update it
        final source = await mapboxMap!.style.getSource("source");
        (source as GeoJsonSource).updateGeoJSON(json.encode(line));
      } else {
        await mapboxMap!.style.addSource(GeoJsonSource(
            id: "source", data: json.encode(line), lineMetrics: true));

        await mapboxMap!.style.addLayer(LineLayer(
          id: 'layer',
          sourceId: 'source',
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
          lineBlur: 1.0,
          lineWidth: 5.0,
          lineColor: Colors.deepOrangeAccent.value,
          // lineDasharray: [1.0, 2.0],
          // lineTrimOffset: [0.0, 0.0],
          // lineWidth: 5.0,
        ));
      }

      // query line layer
      final lineLayer = await mapboxMap!.style.getLayer('layer') as LineLayer;

      // draw layer with gradient
      // mapboxMap!.style.setStyleLayerProperty("layer", "line-gradient",
      //     '["interpolate",["linear"],["line-progress"],0.0,["rgb",255,0,0],0.4,["rgb",0,255,0],1.0,["rgb",0,0,255]]');
      // blue only line
      mapboxMap!.style
          .setStyleLayerProperty("layer", "line-gradient", '["rgb",0,0,255]');

      // animate layer to reveal it from start to end
      controller?.stop();
      controller = AnimationController(
          duration: const Duration(seconds: 1), vsync: mapState);
      animation = Tween<double>(begin: 0, end: 1.0).animate(controller!)
        ..addListener(() async {
          // set the animated value of lineTrim and update the layer
          lineLayer.lineTrimOffset = [animation?.value, 1.0];
          (mapState.mapboxMap.style as StyleManager).updateLayer(lineLayer);
        });
      controller?.forward();
    });
  }

  void drawRouteFromStops(List<Position> stops) async {
    _drawRoute(await _fetchOptimizedRouteCoordinate(stops));
  }
}

Future<List<Position>> _fetchRouteCoordinates(
    Position start, Position end) async {
  final geometries =
      await DrivingAPI(apiKey: mapboxDL).routeCoordinatePolygon(start, end);
  return Polyline.decode(geometries);
}

// optimized route
Future<List<Position>> _fetchOptimizedRouteCoordinate(
    List<Position> stops) async {
  final geometries =
      await OptimizationAPI(apiKey: mapboxDL).optimizedRoute(stops);
  return geometries['coordinates']
      .map<Position>((e) => Position(e[0], e[1]))
      .toList();
}
