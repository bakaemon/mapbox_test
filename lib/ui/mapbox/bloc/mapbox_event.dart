import 'package:freezed_annotation/freezed_annotation.dart';

part 'mapbox_event.freezed.dart';

abstract class MapboxEvent {
  const MapboxEvent();
}

@freezed
class SearchLocation extends MapboxEvent with _$SearchLocation {
  const factory SearchLocation({
    @Default('') String location,
  }) = _SearchLocation;
}

// @freezed
// class JumpToLocation extends MapboxEvent with _$JumpToLocation {
//   const factory JumpToLocation({
//     required MapboxMapController controller,
//     @Default('') String? address,
//     @Default([0, 0]) List<double>? latLng, // for high accuracy
//   }) = _JumpToLocation;
// }
