import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:parking_app/controller/utils/base_url.dart';
import 'package:parking_app/controller/utils/shared_preferences_service.dart';
import '../../models/get_parking_lots_model.dart';

class ParkingApis {

  Future<GetParkingLotsModel> getParkingInfo() async {
    final url = Uri.parse('$baseUrl/parking/get-parking-info');

    try {
      final token = await SharedPreferencesService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log('Parking Info Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final parkingData = data['data'];
          List<dynamic> parkingList;
          if (parkingData is List) {
            parkingList = parkingData;
          } else if (parkingData is Map) {
            parkingList = [parkingData];
          } else {
            parkingList = [];
          }
          final newData = {
            "success": data["success"],
            "message": data["message"],
            "data": parkingList,
          };
          return getParkingLotsModelFromJson(json.encode(newData));
        } else {
          throw Exception('Failed to load parking info');
        }
      } else {
        throw Exception('Failed to load parking info');
      }
    } catch (e) {
      throw Exception('Error fetching parking info: $e');
    }
  }

  Future<Map<String, dynamic>> setParkingInfo(int totalParkingSlots, int pricePerSlot) async {
    final url = Uri.parse('$baseUrl/parking/set-parking-info');

    try {
      final token = await SharedPreferencesService.getToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'totalParkingSlots': totalParkingSlots,
          'pricePerSlot': pricePerSlot,
        }),
      );
      log('Set Parking Info Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to set parking info');
      }
    } catch (e) {
      throw Exception('Error setting parking info: $e');
    }
  }

  // New method to get parking entries
  Future<Map<String, dynamic>> getParkingEntries() async {
    try {
      final token = await SharedPreferencesService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/parking/get-parking-entries'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch parking entries',
        };
      }
    } catch (e) {
      log("error $e");
      return {
        'success': false,
        'message': 'Error fetching parking entries: $e',
      };
    }
  }

  // New method to exit parking entry
  Future<Map<String, dynamic>> exitParkingEntry(String entryId) async {
    try {
      final token = await SharedPreferencesService.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token not found',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/parking/exit-parking-entry/$entryId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to exit parking entry',
        };
      }
    } catch (e) {
      log("error $e");
      return {
        'success': false,
        'message': 'Error exiting parking entry: $e',
      };
    }
  }
}
