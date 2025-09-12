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
        // The data field is an object, not a list, so parse accordingly
        if (data['success'] == true) {
          final parkingData = data['data'];
          // If parkingData is a map, convert to list with one element
          List<dynamic> parkingList;
          if (parkingData is List) {
            parkingList = parkingData;
          } else if (parkingData is Map) {
            parkingList = [parkingData];
          } else {
            parkingList = [];
          }
          // Create a new map with data as list
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
}
