import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;

class MapboxService {
  static const String _accessToken = 'pk.eyJ1IjoiaXNyYXJrMzEzIiwiYSI6ImNtZmg2ZnpieDA4MmIyanF0cGJheThyYXEifQ.BFlPl5Zn1zSIVkcb4hMzDQ';
  
  static Future<Map<String, dynamic>> getNavigationRoute(geo.Position userLocation, double destLat, double destLng) async {
    try {
      final directionsEndpoint = 'https://api.mapbox.com/directions/v5/mapbox/driving/' +
          '${userLocation.longitude},${userLocation.latitude};' +
          '$destLng,$destLat';

      final uri = Uri.parse(directionsEndpoint).replace(queryParameters: {
        'access_token': _accessToken,
        'overview': 'full',
        'geometries': 'geojson',
      });

      // TODO: Implement HTTP request to get route
      // You'll need to add http package and make the API call
      // Return the route geometry and other relevant data

      return {
        'geometry': [], // This will be the route coordinates
        'distance': 0,
        'duration': 0,
      };
    } catch (e) {
      throw Exception('Failed to get navigation route: $e');
    }
  }

  static Future<List<mapbox.Point>> decodePolyline(List<dynamic> geometry) async {
    // TODO: Implement polyline decoding
    // Convert the geometry to a list of Points for the map
    return [];
  }
}
