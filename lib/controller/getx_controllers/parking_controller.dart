import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/get_parking_lots_model.dart';
import '../api_services/parking_apis.dart';

class ParkingController extends GetxController {
  var isLoading = false.obs;
  var parkingLots = Rxn<GetParkingLotsModel>();

  final ParkingApis _parkingApis = ParkingApis();

  @override
  void onInit() {
    super.onInit();
    fetchParkingInfo();
  }

  Future<void> fetchParkingInfo() async {
    try {
      isLoading.value = true;
      final data = await _parkingApis.getParkingInfo();
      parkingLots.value = data;
    } catch (e) {
      // Handle error, e.g. show snackbar or log
      print('Error fetching parking info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setParkingInfo(int totalParkingSlots, int pricePerSlot) async {
    try {
      isLoading.value = true;
      final response = await _parkingApis.setParkingInfo(totalParkingSlots, pricePerSlot);
      if (response['success'] == true) {
        // Refresh the parking data
        await fetchParkingInfo();
        Get.snackbar(
          'Success',
          'Parking info updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update parking info',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update parking info: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
