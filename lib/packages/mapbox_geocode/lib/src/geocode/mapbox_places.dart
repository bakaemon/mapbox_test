//  Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/')
import 'package:mapbox_geocode/mapbox_geocode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapBoxPlaces extends GeoCoding {
  MapBoxPlaces({
    required String apiKey,
    String? language,
    String? country,
    int? limit,
    BBox? bbox,
  }) : super(
          baseUri:
              Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/'),
          apiKey: apiKey,
          language: language,
          country: country,
          limit: limit,
          bbox: bbox,
        );
  @override
  Uri createUrl(
    String queryText, [
    Proximity proximity = const NoProximity(),
  ]) {
    final finalUri = Uri(
      scheme: baseUri!.scheme,
      host: baseUri!.host,
      path: '${baseUri!.path}${Uri.encodeFull(queryText)}.json',
      queryParameters: {
        'access_token': apiKey,
        // ...switch (proximity) {
        //   (LocationProximity l) => {"proximity": l.asString},
        //   (IpProximity _) => {"proximity": 'ip'},
        //   (NoProximity _) => {},
        // },
        if (proximity is LocationProximity) 'proximity': proximity.asString,
        if (proximity is IpProximity) 'proximity': 'ip',
        if (country != null) 'country': country,
        if (limit != null) 'limit': limit.toString(),
        if (language != null) 'language': language,
        if (types.isNotEmpty) 'types': types.map((e) => e.value).join(','),
        if (bbox != null) 'bbox': bbox?.asString,
      },
    );
    return finalUri;
  }

  /// Get the places for the given query text
  Future<ApiResponse<List<MapBoxPlace>>> getPlaces(
    String queryText, {
    @Deprecated('Use `proximity` instead, if `proximity` value is passed then it will be used and this value will be ignored')
        Location? location,
    Proximity proximity = const NoProximity(),
  }) async {
    if (proximity is! Location) {
      proximity =
          location != null ? Proximity.location(location) : const NoProximity();
    }
    final uri = createUrl(queryText, proximity);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      // return (
      //   success: null,
      //   failure: FailureResponse.fromJson(json.decode(response.body))
      // );
      return ApiResponse(
        failure: FailureResponse.fromJson(json.decode(response.body)),
      );
    }

    // return (
    //   success: Predictions.fromJson(json.decode(response.body)).features,
    //   failure: null
    // );
    return ApiResponse(
      success: Predictions.fromJson(json.decode(response.body)).features,
    );
  }

  /// Get the address of the given location coordinates
  Future<ApiResponse<List<MapBoxPlace>?>> getAddress(Location location) async {
    // Assert that if limit is not null then only one type is passed
    assert(limit != null && (types.length == 1) || limit == null,
        'Limit is not null so you can only pass one type');
    Uri uri = createUrl(location.asString);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      // return (
      //   success: null,
      //   failure: FailureResponse.fromJson(json.decode(response.body))
      // );
      return ApiResponse(
        failure: FailureResponse.fromJson(json.decode(response.body)),
      );
    }

    // return (
    //   success: Predictions.fromJson(json.decode(response.body)).features,
    //   failure: null
    // );
    return ApiResponse(
      success: Predictions.fromJson(json.decode(response.body)).features,
    );
  }
}
