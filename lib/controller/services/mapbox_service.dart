import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routes = data['routes'] as List<dynamic>;
        if (routes.isNotEmpty) {
          final route = routes[0] as Map<String, dynamic>;
          final geometry = route['geometry']['coordinates'] as List<dynamic>;
          final distance = route['distance'] as double;
          final duration = route['duration'] as double;

          return {
            'geometry': geometry,
            'distance': distance,
            'duration': duration,
          };
        } else {
          throw Exception('No routes found');
        }
      } else {
        throw Exception('Failed to fetch route: ${response.statusCode}');
      }
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
