library mapbox_geocode;

export 'src/search_api.dart';
export 'models/bbox.dart';
export 'models/failure_response.dart';
export 'models/location.dart';
export 'models/place_type.dart';
export 'enums/maki_icons.dart';
export 'enums/poi_category.dart';
export 'src/geocode/geocoding_api.dart';
export 'models/mapbox_place.dart';
export 'models/suggestion_response.dart';
export 'models/proximity.dart';
export 'models/predictions.dart';

class MapBoxSearch {
  static String? apiKey;

  MapBoxSearch.init(String apiKey) {
    apiKey = apiKey;
  }
}
