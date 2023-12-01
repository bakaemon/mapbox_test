import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:mapbox_test/token.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import '../../../utils/location_utils.dart';

class MapScreenWidget extends StatefulWidget {
  @override
  State<MapScreenWidget> createState() => _MapScreenWidgetState();
}

class _MapScreenWidgetState extends State<MapScreenWidget> {
  // ELIGIBLE FOR REUSE
  MapboxMap? mapboxMap;
  bool _userlocationTracking = false;
  Timer? _timer;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? circleAnnotationManager;
  // --->

  String searchValue = '';
  List<String> suggestions = [];

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
  }

  void refreshTrackLocation() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
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
        zoom: 12,
      ),
      // animate the camera to the new position over a dynamic distance
      MapAnimationOptions(
        duration: 500,
      ),
    );
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
          mapOptions: MapOptions(
            pixelRatio: 1.0,
            constrainMode: ConstrainMode.HEIGHT_ONLY,
          ),
          onMapCreated: _onMapCreated,
          onScrollListener: _onScrollListener,
          onTapListener: (coordinate) {
            // pointAnnotationManager?.create(
            //   PointAnnotationOptions(
            //     geometry: coordinate.toPoint().toJson(),
            //     iconImage: 'airport-15',
            //     iconSize: 5,
            //   ),
            // );
            circleAnnotationManager?.create(
              CircleAnnotationOptions(
                geometry: coordinate.toPoint().toJson(),
                circleRadius: 10,
                circleColor: Colors.orange.value,
              ),
            );
          }),
      floatingActionButton: _fab(),
    );
  }
}
