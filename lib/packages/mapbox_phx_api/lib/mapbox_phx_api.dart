library mapbox_geocode;

export 'src/navigation/driving_api.dart';
export 'src/search_box/search_box.dart';
export 'enums/maki_icons.dart';
export 'enums/poi_category.dart';

class MapBoxPHX {
  static String? apiKey;

  MapBoxPHX.init(String apiKey) {
    apiKey = apiKey;
  }
}
