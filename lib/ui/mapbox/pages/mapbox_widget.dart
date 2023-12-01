// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:easy_search_bar/easy_search_bar.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:mapbox_test/utils/location_utils.dart';
// import '../../../token.dart';
// import '../bloc/mapbox_bloc.dart';
// import '../bloc/mapbox_event.dart';
// import '../bloc/mapbox_state.dart';
// import 'package:mapbox_geocode/mapbox_geocode.dart';

// class MapBoxWidget extends StatefulWidget {
//   @override
//   _MapBoxWidgetState createState() => _MapBoxWidgetState();
// }

// class _MapBoxWidgetState extends State<MapBoxWidget> {
//   LatLng defaultLocation = const LatLng(21.0278, 105.8342);
//   late MapboxBloc bloc;

//   late MapboxMapController mapController;
//   bool isLocationEnabled = false;
//   IconData fabIcon = Icons.location_off;
//   void Function() fabOnPressed = () {};
//   String searchValue = '';

//   @override
//   void initState() {
//     super.initState();
//     bloc = BlocProvider.of<MapboxBloc>(context);

//     LocationUtils.isLocationPermissionGranted().then((isEnable) {
//       if (isEnable) {
//         setState(() {
//           isLocationEnabled = true;
//           LocationUtils.getCurrentLocation().then((value) {
//             currentUserLocation = LatLng(value.latitude, value.longitude);
//           });
//           fabIcon = Icons.location_on;
//           fabOnPressed = () {
//             // locate current user location in r
//             if (currentUserLocation != null) {
//               mapController.animateCamera(
//                 CameraUpdate.newLatLng(
//                   currentUserLocation!,
//                 ),
//               );
//               return;
//             }
//             LocationUtils.getCurrentLocation().then((value) {
//               currentUserLocation = LatLng(value.latitude, value.longitude);
//               mapController.animateCamera(
//                 CameraUpdate.newLatLng(
//                   currentUserLocation!,
//                 ),
//               );
//             });
//           };
//         });
//       } else {
//         setState(() {
//           isLocationEnabled = false;
//           fabIcon = Icons.location_off;
//           fabOnPressed = () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('Please enable location service'),
//                 action: SnackBarAction(
//                   label: 'Enable',
//                   onPressed: () {
//                     setState(() {
//                       LocationUtils.requestLocationService().then((value) {
//                         if (value) {
//                           setState(() {
//                             isLocationEnabled = true;
//                             fabIcon = Icons.location_on;
//                             fabOnPressed = () {
//                               if (currentUserLocation != null) {
//                                 mapController.animateCamera(
//                                   CameraUpdate.newLatLng(
//                                     currentUserLocation!,
//                                   ),
//                                 );
//                                 return;
//                               }
//                               LocationUtils.getCurrentLocation().then((value) {
//                                 currentUserLocation =
//                                     LatLng(value.latitude, value.longitude);
//                                 mapController.animateCamera(
//                                   CameraUpdate.newLatLng(
//                                     currentUserLocation!,
//                                   ),
//                                 );
//                               });
//                             };
//                           });
//                         }
//                       });
//                     });
//                   },
//                 ),
//               ),
//             );
//           };
//         });
//       }
//     });
//     downloadOfflineRegion(
//         OfflineRegionDefinition(
//           // bound the whole Hanoi city
//           bounds: LatLngBounds(
//             southwest: const LatLng(20.9093, 105.6522),
//             northeast: const LatLng(21.1681, 106.012),
//           ),
//           // set the min/max zoom
//           minZoom: 10,
//           maxZoom: 16,
//           // set the style
//           mapStyleUrl: 'mapbox://styles/mapbox/streets-v11',
//           // set the region name
//         ),
//         accessToken: mapboxDL);
//   }

//   LatLng? currentUserLocation;

//   late CameraPosition kInitialPosition;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MapboxBloc, MapboxState>(
//       bloc: bloc,
//       builder: (context, state) {
//         return Scaffold(
//           drawer: Drawer(
//               child: ListView(padding: EdgeInsets.zero, children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Drawer Header'),
//             ),
//             ListTile(
//                 title: const Text('Item 1'),
//                 onTap: () => Navigator.pop(context)),
//             ListTile(
//                 title: const Text('Item 2'),
//                 onTap: () => Navigator.pop(context))
//           ])),
          // appBar: EasySearchBar(
          //   title: const Text('MapScreen'),
          //   // search bar on appbar

          //   onSearch: (value) {
          //     setState(() {
          //       searchValue = value;
          //       bloc.add(JumpToLocation(
          //           controller: mapController, address: searchValue));
          //     });
          //   },
          //   asyncSuggestions: (value) async {
          //     if (value.isEmpty) {
          //       return [];
          //     }
          //     final searchAPI =
          //         SearchAPI(apiKey: mapboxDL, limit: 5, country: 'vn');
          //     final result = await searchAPI.getSuggestions(value);
          //     if (result.success != null) {
          //       final suggestion = result.success!.suggestions!
          //           .map((e) => e!.name ?? 'N/A')
          //           .toList();
          //       return suggestion;
          //     } else {
          //       return ['No result'];
          //     }
          //   },
          //   onSuggestionTap: (data) {
          //     // jump to location
          //     bloc.add(
          //       JumpToLocation(controller: mapController, address: data),
          //     );
          //   },
          // ),
//           body: StreamBuilder(
//               stream: LocationUtils.getPositionStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   currentUserLocation =
//                       LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
//                 }
//                 return MapWidget(resourceOptions: )
//           // fab button to locate current user location
//           floatingActionButton: FloatingActionButton(
//             onPressed: fabOnPressed,
//             child: Icon(fabIcon),
//           ),
//         );
//       },
//     );
//   }
// }
