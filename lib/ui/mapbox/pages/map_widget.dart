import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/generated_assets/assets.gen.dart';
import 'package:mapbox_phx_api/mapbox_phx_api.dart';
import 'package:mapbox_test/token.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:mapbox_test/ui/mapbox/util/annotation_listener.dart';
import 'package:mapbox_test/ui/mapbox/util/annotation_utils.dart';
import 'package:mapbox_test/ui/mapbox/util/route_utils.dart';
import '../util/location_utils.dart';
import '../util/unit_utils.dart';

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
  bool _enablePuck = true;
  bool _pulsingPuck = true;
  bool _accuracyRing = true;
  Timer? _timer;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;
  RouteUtil? routeUtil;
  final defaultEdgeInsets =
      MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);
  num _duration = 0.0; // in seconds
  num _distance = 0.0; // in meters
  // --->
  String searchValue = '';
  List<String> suggestions = [];
  List<PointAnnotation> stops = [];

  @override
  void initState() {
    super.initState();
    LocationUtils.isLocationPermissionGranted().then((isEnable) {
      if (isEnable) {
        setState(() {
          _enablePuck = true;
          _pulsingPuck = true;
          _accuracyRing = true;
        });
        setState(() {
          _userlocationTracking = !_userlocationTracking;
          refreshTrackLocation();
        });
      }
    });
  }

  PreferredSizeWidget _searchAppBar() => EasySearchBar(
        title:
            Text('MapScreen (${_distance.toKilometers.toStringAsFixed(1)} km, '
                '${_duration.toMinutes.toInt()} min)'),
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
        // // animate the camera to the new position over a dynamic distance
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
                            _enablePuck = true;
                            _pulsingPuck = true;
                            _accuracyRing = true;
                          });
                          setDefaultLayer();
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

  void setDefaultCamera() {
    mapboxMap?.setCamera(CameraOptions(
      center: Point(
        coordinates: Position(
          105.8342,
          21.0278,
        ),
      ).toJson(),
      zoom: 12,
    ));
  }

  void setDefaultLayer() async {
    await mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: _enablePuck,
        pulsingEnabled: _pulsingPuck,
        pulsingColor: Colors.orange.shade500.withOpacity(0.5).value,
        accuracyRingColor: Colors.orange.shade100.withOpacity(0.5).value,
        showAccuracyRing: _accuracyRing,
        locationPuck: LocationPuck(
          locationPuck2D: LocationPuck2D(
            topImage: (await rootBundle.load(Assets.images.bus.path))
                .buffer
                .asUint8List(),
          ),
        ),
        // puckBearingEnabled: true,
      ),
    );
  }

  void setAnnotationManager() async {
    pointAnnotationManager =
        await mapboxMap?.annotations.createPointAnnotationManager();
    circleAnnotationManager =
        await mapboxMap?.annotations.createCircleAnnotationManager();
  }

  void setAnnotationListeners() async {
    pointAnnotationManager?.addOnPointAnnotationClickListener(
      DeletePointAnnotationListener(pointAnnotationManager!, onDeleted: (_) {
        setState(() {});
      }),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    routeUtil = RouteUtil.of(this);
    // set camera position and zoom
    setDefaultCamera();
    // add symbol layer
    setDefaultLayer();
    // set annotation managers
    setAnnotationManager();
    // set annotation listeners
    setAnnotationListeners();
  }

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
            final durationAndDistance = await routeUtil?.drawRoute(
                stops.map((e) => e.toPosition()).toList(),
                routeType: RouteType.animated,
                color: Colors.deepOrangeAccent);
            setState(() {
              _distance = durationAndDistance!.last;
              _duration = durationAndDistance.first;
            });
          }
        },
      ),
      floatingActionButton: _fab(),
    );
  }
}
