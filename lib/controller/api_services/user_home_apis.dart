import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:parking_app/controller/utils/base_url.dart';

import '../utils/api_endpoints.dart';
import '../utils/shared_preferences_service.dart';

class UserHomeApis {
  // Find parkings within radius
  Future<Map<String, dynamic>> findParkings({
    required double lat,
    required double lng,
    required int distance,
  }) async {
    try {
      log("Finding parkings at lat: $lat, lng: $lng, distance: $distance km");
      final token = await SharedPreferencesService.getToken();
      
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/find-parkings?lat=$lat&lng=$lng&distance=$distance'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log("Response Status: ${response.statusCode} Response body: ${response.body}");

      final responseData = jsonDecode(response.body);
      log("Response Data: $responseData");
      
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch parking lots',
        };
      }
    } catch (e) {
      log("error $e");
      return {
        'success': false,
        'message': 'Error fetching parking lots: $e',
      };
    }
  }

  // Make entry to parking
  Future<Map<String, dynamic>> makeEntryToParking({
    required String carNumber,
    required String parkingOwnerId,
  }) async {
    try {
      log("Making entry to parking with car number: $carNumber");
      final token = await SharedPreferencesService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/make-entry-to-parking'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "parkingOwnerId": parkingOwnerId,
          "carNumber": carNumber,
        }),
      );
      log("Response Status: ${response.statusCode} Response body: ${response.body}");

      final responseData = jsonDecode(response.body);
      log("Response Data: $responseData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to make entry to parking',
        };
      }
    } catch (e) {
      log("error $e");
      return {
        'success': false,
        'message': 'Error making entry to parking: $e',
      };
    }
  }
}
