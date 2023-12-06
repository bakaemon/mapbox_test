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
  const MapScreenWidget({
    super.key,
    this.address = const [],
    this.streamBusLocation,
    this.focusAddress,
  });

  final List<String> address;
  final Stream<Position>? streamBusLocation;
  final String? focusAddress;

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
  late SearchBox searchAPI;
  bool _isFetchingStops = false;
  PointAnnotation? busAnnotation;
  List<Position> busTrail = [];
  // --->
  String searchValue = '';
  List<Suggestion> suggestions = [];
  List<PointAnnotation> stops = [];

  @override
  void initState() {
    super.initState();
    searchAPI = SearchBox(apiKey: mapboxDL);
    LocationUtils.isLocationPermissionGranted().then((isEnable) {
      if (isEnable) {
        setState(() {
          _enablePuck = true;
          _pulsingPuck = true;
          _accuracyRing = true;
        });
      }
    });
  }

  Future<void> _loadStopsFromAddresses({
    int tryCount = 0,
  }) async {
    _isFetchingStops = true;

    try {
      if (tryCount > 10) {
        throw Exception(
            'Geocoding requests exceeded > 10. Check your internet connection.');
      }
      if (widget.address.isEmpty) {
        _isFetchingStops = false;
        return;
      }
      for (final address in widget.address) {
        final result = await LocationUtils.getAddressMapboxPosition(address);

        addPoint(result.toPoint());
      }
      _isFetchingStops = false;
      return;
    } catch (e) {
      _isFetchingStops = false;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK')),
          ],
        ),
      );
      return _loadStopsFromAddresses(tryCount: tryCount + 1);
    }
  }

  Future<PointAnnotation?> addPoint(Point point, {bool asStop = true}) async {
    return pointAnnotationManager
        ?.addPinAnnotation(
      point,
    )
        .then(
      (anno) {
        if (asStop) {
          stops.addPoint(
            anno,
            onAdded: () async {
              if (stops.length > 1) {
                final durationAndDistance = await routeUtil?.optimize(
                  stops.map((e) => e.toPosition()).toList(),
                  // routeType: RouteType.animated,
                  // color: Colors.deepOrangeAccent,
                );
                setState(() {
                  _distance = durationAndDistance!.last;
                  _duration = durationAndDistance.first;
                });
              }
            },
          );
        }
      },
    );
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

          final result =
              await searchAPI.profile<SuggestProfile>().searchSuggestions(
                    query: value,
                    country: 'vn',
                  );
          if (result.isNotEmpty) {
            setState(() {
              suggestions = result;
            });
            final suggestion = result.map((e) => e.placeFormatted).toList();
            return suggestion;
          } else {
            return ['No result'];
          }
        },
        onSuggestionTap: (placeFormatted) async {
          final result = await searchAPI
              .profile<RetrieveProfile>()
              .retrieveResult(
                  mapboxId: suggestions
                      .where((e) => e.placeFormatted == placeFormatted)
                      .first
                      .mapboxId);
          final suggestionPosition = result.features.first.geometry.coordinates;
          addPoint(
            Position(suggestionPosition.first, suggestionPosition.last)
                .toPoint(),
          );
          mapboxMap?.flyTo(
            CameraOptions(
              center: Point(
                coordinates: Position(
                  suggestionPosition.first,
                  suggestionPosition.last,
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

  void followPosition(Future<Position> Function()? positionGetter) async {
    _timer?.cancel();
    if (_isFetchingStops || busAnnotation == null) {
      return;
    }
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!_userlocationTracking) {
        _timer?.cancel();
        return;
      }

      // final Position puckLocation = await mapboxMap!.style.getPuckPosition();
      // final Position puckLocation = busAnnotation!.toPosition();

      // Some function that changes the camera of the map.
      _setCameraPosition(await positionGetter?.call());
    });
  }

  void _setCameraPosition(Position? puckLocation) {
    if (puckLocation == null) {
      return;
    }
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
                      LocationUtils.requestLocationService()
                          .then((value) async {
                        if (value) {
                          setState(() {
                            _enablePuck = true;
                            _pulsingPuck = true;
                            _accuracyRing = true;
                          });
                          setDefaultLayer();
                          setState(() {
                            _userlocationTracking = !_userlocationTracking;
                            followPosition(mapboxMap?.style.getPuckPosition);
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
      followPosition(() async {
        return Future.value(busAnnotation?.toPosition());
      });
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
        coordinates: stops.isEmpty
            ? Position(
                105.8342,
                21.0278,
              )
            : stops.first.toPosition(),
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

    // add symbol layer
    setDefaultLayer();
    // set annotation managers
    setAnnotationManager();
    // set annotation listeners
    setAnnotationListeners();
    // load stops
    await _loadStopsFromAddresses();

    // set camera position and zoom
    setDefaultCamera();

    if (widget.focusAddress != null) {
      LocationUtils.getAddressMapboxPosition(widget.focusAddress!)
          .then((position) {
        if (!widget.address.contains(widget.focusAddress)) {
          addPoint(position.toPoint(), asStop: false);
        }
        _setCameraPosition(position);
      });
    }

    widget.streamBusLocation?.listen(_updateBusLocation);
  }

  Future<void> _updateBusLocation(Position position) async {
    if (busAnnotation == null) {
      busAnnotation = await pointAnnotationManager?.addPinAnnotation(
        position.toPoint(),
      );
      // start direction
      pointAnnotationManager?.addAnnotation(
          point: position.toPoint(), image: Assets.images.bus.path);
    } else {
      busAnnotation = busAnnotation!.copyWith(
        geometry: position.toPoint().toJson(),
      );
      await pointAnnotationManager?.update(busAnnotation!);
      busTrail.add(busAnnotation!.toPosition());
      routeUtil?.drawTrail(busTrail);
    }
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
          addPoint(coordinate.toPoint());
        },
      ),
      floatingActionButton: _fab(),
    );
  }
}
