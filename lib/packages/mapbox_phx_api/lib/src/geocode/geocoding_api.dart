

import '../../mapbox_phx_api.dart';
import 'mapbox_places.dart';

/// The MapBox Geocoding API lets you convert location text into geographic coordinates (1600 Pennsylvania Ave NW → -77.0366,38.8971)
/// and vice versa (reverse geocoding).
///
/// https://docs.mapbox.com/api/search/geocoding/
class GeoCoding {
  /// API Key of the MapBox.
  String? apiKey;

  /// Specify the user’s language. This parameter controls the language of the text supplied in responses.
  ///
  /// Check the full list of [supported languages](https://docs.mapbox.com/api/search/#language-coverage) for the MapBox API
  final String? language;

  ///Limit results to one or more countries. Permitted values are ISO 3166 alpha 2 country codes separated by commas.
  ///
  /// Check the full list of [supported countries](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) for the MapBox API
  final String? country;

  /// Specify the maximum number of results to return. The default is 5 and the maximum supported is 10.
  final int? limit;

  /// Limit results to only those contained within the supplied bounding box.
  final BBox? bbox;

  /// Filter results to include only a subset (one or more) of the available feature types.
  /// Options are country, region, postcode, district, place, locality, neighborhood, address, and poi.
  /// Multiple options can be comma-separated.
  ///
  /// For more information on the available types, see the [data types section](https://docs.mapbox.com/api/search/geocoding/#data-types).
  final List<PlaceType> types;

  final Uri? baseUri;

  /// The MapBox Places API lets you convert location text into geographic coordinates
  MapBoxPlaces get mapboxPlaces => MapBoxPlaces(
        apiKey: apiKey!,
        language: language,
        country: country,
        limit: limit,
        bbox: bbox,
      );

  /// If [apiKey] is not provided here then it must be provided [MapBoxSearch()]
  GeoCoding({
    this.baseUri,
    this.apiKey,
    this.country,
    this.limit,
    this.language,
    this.types = const [PlaceType.address],
    this.bbox,
  }) {
    if (apiKey == null && MapBoxSearch.apiKey == null) {
      throw ArgumentError.notNull(
          'apiKey must be provided either in constructor or in MapBoxSearch.init()');
    }
    apiKey ??= MapBoxSearch.apiKey;
  }

  Uri createUrl(
    String queryText, [
    Proximity proximity = const NoProximity(),
  ]) {
    throw UnimplementedError();
  }

  GeoCoding copyWith({
    String? apiKey,
    String? language,
    String? country,
    int? limit,
    BBox? bbox,
    List<PlaceType>? types,
  }) {
    return GeoCoding(
      baseUri: baseUri,
      apiKey: apiKey ?? this.apiKey,
      language: language ?? this.language,
      country: country ?? this.country,
      limit: limit ?? this.limit,
      bbox: bbox ?? this.bbox,
      types: types ?? this.types,
    );
  }
}
