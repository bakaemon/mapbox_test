import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_phx_api/mapbox_phx_api.dart';
import 'package:mapbox_test/token.dart';
import 'package:mapbox_test/ui/mapbox/util/location_utils.dart';

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

  Direction directionAPI = Direction(apiKey: mapboxDL);

  num duration = 0.0; // in seconds
  num distance = 0.0; // in meters

  /// Create a [RouteUtil] from a [State] with [TickerProviderStateMixin].
  /// The [State] must have field `mapboxMap`
  /// of type [MapboxMap] containing the map.
  factory RouteUtil.of(dynamic mapState) => RouteUtil._(mapState);

  /// Draw a route from current location to a given [Position]
  Future<List<num>> drawFromCurrentTo(Position position) async {
    final start = await mapboxMap!.style.getPuckPosition();
    drawRoute([start, position]);
    return [duration, distance];
  }

  /// Draw a route from given [Position] objects.
  Future<List<num>> drawRoute(
    List<Position> stops, {
    RouteType routeType = RouteType.line,
    Color? color,
  }) async {
    _drawRoute(await _fetchRouteCoordinates(stops),
        routeType: RouteType.animated, color: color);
    return [duration, distance];
  }

  /// Draw a custom trail role from coordinates [Position] objects.
  Future<void> drawTrail(
    List<Position> coordinates, {
    Color? color,
  }) {
    return _drawRoute(
      coordinates,
      routeType: RouteType.line,
      color: color,
    );
  }

  Future<void> _drawRoute(List<Position> polyline,
      {RouteType routeType = RouteType.line, Color? color}) async {
    switch (routeType) {
      case RouteType.line:
        _drawLineRoute(polyline, color: color);
        break;
      case RouteType.animated:
        _drawRouteAnimated(polyline, color: color);
        break;
    }
  }

  /// Draw a line route from given [Position] objects.
  void _drawLineRoute(List<Position> polyline, {Color? color}) async {
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
          lineColor: color?.value ?? Colors.deepOrangeAccent.value,
          lineBlur: 1.0,
          lineWidth: 5.0,
        ));
      }
    });
  }

  /// Draw animated route from given [Position] objects.
  void _drawRouteAnimated(List<Position> polyline, {Color? color}) async {
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
          lineColor: color?.value ?? Colors.deepOrangeAccent.value,
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
      // mapboxMap!.style
      //     .setStyleLayerProperty("layer", "line-gradient", '["rgb",0,0,255]');

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

  Future<List<num>> optimize(List<Position> stops) async {
    _drawRoute(await _fetchOptimizedRouteCoordinate(stops));
    return [duration, distance];
  }

  Future<List<Position>> _fetchRouteCoordinates(List<Position> stops) async {
    final route = await directionAPI
        .profile<DrivingProfile>(
            options: DrivingRouteOptions(
          overview: Overview.full,
        ))
        .routeCoordinate(stops);
    debugPrint('route: $route');
    setDurationAndDistance(route);
    final geometries = route['geometry']; // polyline
    return geometries['coordinates']
        .map<Position>((e) => Position.fromJson(e.cast<num>()))
        .toList();
  }

// optimized route
  Future<List<Position>> _fetchOptimizedRouteCoordinate(
      List<Position> stops) async {
    final trip = await directionAPI
        .profile<OptimizationProfile>(
            options: DrivingRouteOptions(
          geometry: GeometryResponseType.geojson,
          overview: Overview.full,
          roundTrip: false,
          source: 'first', // start from first stop
          destination: 'last', // end at last stop
        ))
        .optimizedRoute(stops);
    setDurationAndDistance(trip);
    final geometries = trip['geometry'];
    return geometries['coordinates']
        .map<Position>((e) => Position.fromJson(e.cast<num>()))
        .toList();
  }

  void setDurationAndDistance(Map<String, dynamic> route) {
    duration = route['duration'] as num;
    distance = route['distance'] as num;
  }
}
