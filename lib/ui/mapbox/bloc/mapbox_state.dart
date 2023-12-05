// freezed
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mapbox_state.freezed.dart';

@freezed
abstract class MapboxState with _$MapboxState {
  const factory MapboxState({
    @Default([0, 0]) List<double> latLng,
    // @Default([]) List<Suggestion> suggestions,
  }) = _MapboxState;
}
