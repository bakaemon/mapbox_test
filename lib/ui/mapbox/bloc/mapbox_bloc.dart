import 'package:bloc/bloc.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'mapbox_event.dart';
import 'mapbox_state.dart';


class MapboxBloc extends Bloc<MapboxEvent, MapboxState> {
  late MapboxEvent event;
  MapboxBloc() : super(const MapboxState()) {
    // on<SearchLocation>(
    //   _searchLocationEvent,
    //   // debounce event
    //   // transformer: (events, mapper) => events.debounceTime(
    //   //   const Duration(milliseconds: 500),
    //   // ),
    // );

    // on<JumpToLocation>(_jumpToLocationEvent);
  }

  // void _searchLocationEvent(
  //     SearchLocation event, Emitter<MapboxState> emit) async {
  //   // search location and transform to latlng
  //   final mapbox_geocode.SearchAPI searchAPI = mapbox_geocode.SearchAPI(
  //     apiKey: mapboxDL,
  //     limit: 5,
  //     country: 'vn',
  //   );
  //   if (event.location.isEmpty) {
  //     emit(state.copyWith(suggestions: []));
  //     return;
  //   }
  //   debugPrint('Search location: ${event.location}');
  //   final result = await searchAPI.getSuggestions(event.location);
  // if (result.success != null) {
  //   emit(
  //     state.copyWith(
  //       suggestions: result.success!.suggestions!.map((e) => e!).toList(),
  //     ),
  //   );
  //   debugPrint('Search result: ${result.success!.suggestions!.length}');
  // } else {
  //   emit(state.copyWith(suggestions: []));
  //   throw Exception(result.failure!.message);
  // }
  // }

  // _jumpToLocationEvent(
  //     JumpToLocation event, Emitter<MapboxState> emitter) async {
  //   if (event.latLng == null && event.address == null) {
  //     return;
  //   }
  //   if (event.latLng != null) {
  //     event.controller.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(event.latLng!.first, event.latLng!.last),
  //       ),
  //     );
  //   } else {
  //     final values = await LocationUtils.getLatLngFromAddress(event.address!);
  //     event.controller.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(values.first, values.last),
  //       ),
  //     );
  //   }
  // }
}
