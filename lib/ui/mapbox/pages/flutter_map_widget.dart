// flutter_map
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_test/token.dart';

class FlutterMapWidget extends StatelessWidget {
  const FlutterMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        // hanoi
        center: LatLng(21.027763, 105.834160),
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          maxNativeZoom: 15,
          urlTemplate:
              'https://api.mapbox.com/styles/v1/binhtq/clpte33kx018t01qt0ov8hher/tiles/256/{z}/{x}/{y}@2x?access_token=$publicToken',
        ),
      ],
    );
  }
}
