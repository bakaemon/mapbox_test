import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:mapbox_test/generated_assets/assets.gen.dart';
import 'package:mapbox_test/token.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:mapbox_test/ui/mapbox/util/annotation_listener.dart';
import 'package:mapbox_test/ui/mapbox/util/annotation_utils.dart';
import 'package:mapbox_test/utils/route_utils.dart';
import '../../../utils/location_utils.dart';

class MapScreenWidget extends StatefulWidget {
  const MapScreenWidget({super.key});

  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget>
    with TickerProviderStateMixin {
  // ELIGIBLE FOR REUSE
  MapboxMap? mapboxMap;
  bool _userlocationTracking = false;
  Timer? _timer;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;
  RouteUtil? routeUtil;
  final defaultEdgeInsets =
      MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);
  // --->
  PointAnnotation? _pinnedAnnotation;
  String searchValue = '';
  List<String> suggestions = [];
  List<PointAnnotation> stops = [];

  @override
  void initState() {
    super.initState();
  }

  PreferredSizeWidget _searchAppBar() => EasySearchBar(
        title: const Text('MapScreen'),
        // search bar on appbar

        onSearch: (value) async {
          setState(() {
            searchValue = value;
          });
        },
        asyncSuggestions: (value) async {
          if (value.isEmpty) {
            return [];
          }
          final searchAPI =
              SearchAPI(apiKey: mapboxDL, limit: 5, country: 'vn');
          final result = await searchAPI.getSuggestions(value);
          if (result.success != null) {
            final suggestion = result.success!.suggestions!
                .map((e) => e!.name ?? 'N/A')
                .toList();
            suggestions = suggestion;
            return suggestion;
          } else {
            return ['No result'];
          }
        },
        onSuggestionTap: (data) async {
          final suggestionPosition =
              await LocationUtils.getLatLngFromAddress(data);
          mapboxMap?.flyTo(
            CameraOptions(
              center: Point(
                coordinates: Position(
                  suggestionPosition.last,
                  suggestionPosition.first,
                  0,
                ),
              ).toJson(),
              zoom: 12,
            ),
            // animate the camera to the new position over a dynamic distance
            MapAnimationOptions(
              duration: 500,
            ),
          );
        },
      );

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    routeUtil = RouteUtil.of(this);
    // set camera position and zoom
    mapboxMap.setCamera(CameraOptions(
      center: Point(
        coordinates: Position(
          105.8342,
          21.0278,
        ),
      ).toJson(),
      zoom: 12,
    ));
    // add symbol layer
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: false,
        showAccuracyRing: true,
        // puckBearingEnabled: true,
      ),
    );

    // add point annotation
    pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    circleAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();
    circleAnnotationManager?.addOnCircleAnnotationClickListener(
      // CircleAnnotationListener((annotation) {
      //   debugPrint('onCircleAnnotationClick: ${annotation.id}');
      //   circleAnnotationManager?.delete(annotation);
      //   _pinnedAnnotation = null;
      // }),
      DeleteCircleAnnotationListener(circleAnnotationManager!, onDeleted: (_) {
        setState(() {
          _pinnedAnnotation = null;
        });
      }),
    );
  }

  void refreshTrackLocation() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!_userlocationTracking) {
        _timer?.cancel();
        return;
      }

      final Position puckLocation = await mapboxMap!.style.getPuckPosition();

      // Some function that changes the camera of the map.
      _setCameraPosition(puckLocation);
    });
  }

  void _setCameraPosition(Position puckLocation) {
    mapboxMap?.flyTo(
        CameraOptions(
          center: Point(
            coordinates: puckLocation,
          ).toJson(),
          zoom: 15,
        ),
        // animate the camera to the new position over a dynamic distance
        // MapAnimationOptions(
        //   duration: 500,
        // ),
        null);
  }

  void _onScrollListener(ScreenCoordinate point) {
    if (_userlocationTracking) {
      setState(() {
        _userlocationTracking = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Location permission'),
              content: const Text('Please enable location permission'),
              actions: [
                // cancel this dialog
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                // request location permission
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      LocationUtils.requestLocationService().then((value) {
                        if (value) {
                          setState(() {
                            _userlocationTracking = !_userlocationTracking;
                            refreshTrackLocation();
                          });
                        }
                      });
                    },
                    child: const Text('OK')),
              ],
            ));
  }

  void _beginTracking() {
    setState(() {
      _userlocationTracking = !_userlocationTracking;
      refreshTrackLocation();
    });
  }

  Widget _fab() => FloatingActionButton(
        onPressed: () {
          setState(() {
            LocationUtils.isLocationPermissionGranted().then((isEnable) {
              if (isEnable) {
                _beginTracking();
              } else {
                _showPermissionDialog();
              }
            });
          });
        },
        child: Icon(
          _userlocationTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchAppBar(),
      body: MapWidget(
        resourceOptions: ResourceOptions(
          accessToken: publicToken,
          tileStoreUsageMode: TileStoreUsageMode.READ_AND_UPDATE,
        ),
        onMapCreated: _onMapCreated,
        onScrollListener: _onScrollListener,
        onTapListener: (coordinate) async {
          final anno = await pointAnnotationManager?.create(
            PointAnnotationOptions(
              geometry: coordinate.toPoint().toJson(),
              image: (await rootBundle.load(Assets.images.bus.path))
                  .buffer
                  .asUint8List(),
              iconSize: 1.5,
            ),
          );
          stops.add(anno!);
          if (stops.length > 1) {
            routeUtil?.drawRouteFromStops(
              stops.map((e) => e.toPosition()).toList(),
            );
          }
        },
      ),
      floatingActionButton: _fab(),
    );
  }

}
