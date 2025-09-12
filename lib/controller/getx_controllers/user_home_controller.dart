import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../api_services/user_home_apis.dart';
import '../../models/get_parking_lots_model.dart';
import '../utils/shared_preferences_service.dart';

class UserHomeController extends GetxController {
  final UserHomeApis _userHomeApis = UserHomeApis();
  
  // Observable variables
  var isLoading = false.obs;
  var parkingLots = Rx<GetParkingLotsModel?>(null);
  var selectedDistance = 10.obs; // Default distance in km
  var markers = RxSet<Marker>();

  // Available distance options
  final List<int> distanceOptions = [5, 10, 15, 20, 25];

  // User's current location
  var userLat = 0.0.obs;
  var userLng = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserLocation();
  }

  // Load user's location from SharedPreferences

Future<void> loadUserLocation() async {
  try {
    // Ask for permission if not already granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    userLat.value = position.latitude;
    userLng.value = position.longitude;

    // Fetch parking lots after loading location
    await findParkingLots();
  } catch (e) {
    print("Error fetching location: $e");
  }
}


  // Find parking lots
  Future<void> findParkingLots() async {
    isLoading.value = true;
    markers.clear(); // Clear existing markers

    try {
      final response = await _userHomeApis.findParkings(
        lat: userLat.value,
        lng: userLng.value,
        distance: selectedDistance.value,
      );

      if (response['success'] == true) {
        // Parse response to model
        parkingLots.value = GetParkingLotsModel.fromJson(response);
        
        // Add markers for each parking lot
        _addParkingMarkers();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to fetch parking lots',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch parking lots: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add markers for parking lots
  void _addParkingMarkers() {
    if (parkingLots.value == null) return;

    // Clear existing markers first
    markers.clear();

    for (var parking in parkingLots.value!.data) {
      print("Adding marker for parking: ${parking.username} at ${parking.lat}, ${parking.lng}"); // Debug print
      
      markers.add(
        Marker(
          markerId: MarkerId(parking.id),
          position: LatLng(parking.lat, parking.lng),
          infoWindow: InfoWindow(
            title: parking.username,
            snippet: 'Available: ${parking.availableParkingSpots} spots\nPrice: ${parking.pricePerSlot}/hour',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }
    
    // Force refresh of markers
    markers.refresh();
  }

  // Update selected distance and refresh parking lots
  Future<void> updateDistance(int distance) async {
    selectedDistance.value = distance;
    await findParkingLots();
  }
}
