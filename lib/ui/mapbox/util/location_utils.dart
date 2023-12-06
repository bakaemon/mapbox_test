import 'dart:io';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart';
// mapbox defined position class
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class LocationUtils {
  // ask for permission
  static Future<bool> requestLocationService() async {
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied ||
        permission == geolocator.LocationPermission.deniedForever) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied ||
          permission == geolocator.LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  static Future<geolocator.Position> getCurrentLocation() async {
    return await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.medium);
  }

  // static Future<LatLng> getCurrentLatLng() async {
  //   Position position = await getCurrentLocation();
  //   return LatLng(position.latitude, position.longitude);
  // }

  static Future<Map<String, dynamic>> getCurrentAddress() async {
    geolocator.Position position = await getCurrentLocation();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return {
      'address':
          '${placemarks[0].street}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}',
      'city': placemarks[0].subAdministrativeArea.toString(),
      'state': placemarks[0].administrativeArea.toString(),
      'country': placemarks[0].country.toString(),
      'postalCode': placemarks[0].postalCode.toString(),
      'name': placemarks[0].name.toString(),
      'isoCountryCode': placemarks[0].isoCountryCode.toString(),
      'lat': position.latitude,
      'lng': position.longitude,
      'latLng': [position.latitude, position.longitude],
    };
  }

  static Future<List<double>> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return [locations[0].latitude, locations[0].longitude];
  }

  static Future<Map<String, dynamic>> getAddressFromLatLng(
      double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    return {
      'address':
          '${placemarks[0].street}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}',
      'city': placemarks[0].subAdministrativeArea.toString(),
      'state': placemarks[0].administrativeArea.toString(),
      'country': placemarks[0].country.toString(),
      'postalCode': placemarks[0].postalCode.toString(),
      'name': placemarks[0].name.toString(),
      'isoCountryCode': placemarks[0].isoCountryCode.toString(),
      'lat': lat,
      'lng': lng,
    };
  }

  // check if location service is enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await geolocator.Geolocator.isLocationServiceEnabled();
  }

  // check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    geolocator.LocationPermission permission =
        await geolocator.Geolocator.checkPermission();
    return permission == geolocator.LocationPermission.always ||
        permission == geolocator.LocationPermission.whileInUse;
  }

  static Stream<geolocator.Position> getPositionStream() {
    return geolocator.Geolocator.getPositionStream(
        locationSettings: const geolocator.LocationSettings(
      accuracy: geolocator.LocationAccuracy.high,
      distanceFilter: 10,
    ));
  }

  static Future<mb.Position> getAddressMapboxPosition(String address) async {
    final location = await locationFromAddress(address);
    return location.first.toMapBoxPosition();
  }
}

extension GeolocatorPositionExtension on geolocator.Position {
  mb.Position toMapBoxPosition() {
    return mb.Position(longitude, latitude, altitude);
  }

}

extension MapBoxPositionExtension on mb.Position {
  mb.Point toPoint() {
    return mb.Point(coordinates: this);
  }
}

extension PuckPosition on StyleManager {
  Future<Position> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    return Future.value(Position(location![1]!, location[0]!));
  }
}

extension ScreenCoordinateExtension on mb.ScreenCoordinate {
  mb.Point toPoint() {
    return mb.Point(coordinates: Position(y, x));
  }

  mb.Position toPosition() {
    return mb.Position(y, x);
  }
}

extension LocationGeolocatorUtil on Location {
  mb.Position toMapBoxPosition() {
    return mb.Position(longitude, latitude);
  }
}