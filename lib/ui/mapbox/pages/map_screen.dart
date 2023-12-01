import 'package:flutter/material.dart';
import 'package:mapbox_test/token.dart';
import 'package:mapbox_test/ui/mapbox/bloc/mapbox_bloc.dart';
import 'package:mapbox_test/ui/mapbox/bloc/mapbox_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        create: (context) => MapboxBloc(), child: MapScreenWidget());
  }
}
