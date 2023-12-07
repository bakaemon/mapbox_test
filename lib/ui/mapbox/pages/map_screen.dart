import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/token.dart';
import 'package:mapbox_test/ui/mapbox/bloc/mapbox_bloc.dart';
import 'package:mapbox_test/ui/mapbox/bloc/mapbox_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_test/ui/mapbox/pages/flutter_map_widget.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_test/ui/mapbox/pages/map_widget.dart';
import 'package:mapbox_test/ui/mapbox/pages/mapbox_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapboxBloc>(
      create: (context) => MapboxBloc(),
      child: MapScreenWidget(
        address: const [
          '165 Cầu Cốc - Tây Mỗ - Nam Từ Liêm, Hà Nội',
          '89 Lê Đức Thọ, Mỹ Đình 2, Nam Từ Liêm, Hà Nội',
          '66 Nguyễn Hoàng, Mỹ Đình, Nam Từ Liêm, Hà Nội',
        ],
        focusAddress: '66 Nguyễn Hoàng, Mỹ Đình, Nam Từ Liêm, Hà Nội',
        enableTrail: true,
        streamBusLocation: Stream.periodic(
          const Duration(milliseconds: 1000),
          (i) => Position(
            105.834160 + i * 0.00001,
            21.027763 + i * 0.000001,
          ),
        ),
      ),
      // child: FlutterMapWidget(),
    );
  }
}
