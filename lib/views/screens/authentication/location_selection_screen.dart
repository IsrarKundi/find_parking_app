import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final AuthController _authController = Get.find<AuthController>();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

Future<void> _getCurrentLocation() async {
  try {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Error',
        'Please enable location services',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Check and request permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Error',
          'Location permissions are denied',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Error',
        'Location permissions are permanently denied, enable them from settings',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 3. Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: _selectedLocation!,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
    );
  } catch (e) {
    Get.snackbar(
      'Location Error',
      'Failed to get current location: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      );
    });
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Select Parking Location',
        style: AppTextStyles.titleBoldUpper.copyWith(
          color: AppColor.whiteColor,
          fontSize: 18.sp,
        ),
      ),
      backgroundColor: AppColor.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
        onPressed: () => Get.back(),
      ),
    ),
    body: _selectedLocation == null
        ? const Center(child: CircularProgressIndicator()) // show loader
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation!, // ✅ start from user location
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: _onMapTap,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              Positioned(
                bottom: 4.h,
                left: 5.w,
                right: 5.w,
                child: Column(
                  children: [
                    if (_selectedLocation != null)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          'Selected: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                          '${_selectedLocation!.longitude.toStringAsFixed(6)}',
                          style: AppTextStyles.bodyRegularUpper.copyWith(
                            color: AppColor.blackColor,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    getVerticalSpace(height: 2.h),
                    CustomElevatedButton(
                      text: 'Confirm Location',
                      onPressed: () {
                        if (_selectedLocation != null) {
                          _authController.setSelectedLocation(
                            Position(
                              latitude: _selectedLocation!.latitude,
                              longitude: _selectedLocation!.longitude,
                              timestamp: DateTime.now(),
                              accuracy: 0.0,
                              altitude: 0.0,
                              altitudeAccuracy: 0.0,
                              heading: 0.0,
                              headingAccuracy: 0.0,
                              speed: 0.0,
                              speedAccuracy: 0.0,
                            ),
                          );
                          Get.back();
                        } else {
                          Get.snackbar(
                            'No Location Selected',
                            'Please select a location on the map',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
  );
}

}