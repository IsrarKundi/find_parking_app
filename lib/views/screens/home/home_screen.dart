import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/shared_preferences_service.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../data/dummy_parking_data.dart';
import '../../../models/parking_model.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../parking_details/parking_details_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final _userProfileImage = RxString('');

  static const CameraPosition _kPeshawar = CameraPosition(
    target: LatLng(34.0151, 71.5249),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    final image = await SharedPreferencesService.getUserImage();
    if (mounted) {
      _userProfileImage.value = image ?? '';
    }
  }

  void _loadMarkers() {
    for (Parking parking in dummyParkings) {
      _markers.add(
        Marker(
          markerId: MarkerId(parking.id),
          position: LatLng(parking.latitude, parking.longitude),
          infoWindow: InfoWindow(
            title: parking.name,
            snippet: 'Available: ${parking.availableSpots} spots',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () {
            Get.to(() => ParkingDetailsScreen(parking: parking));
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Spacer(),
            Image.asset(
              'assets/svgs/parking_logo.png',
              height: 30.sp,
            ),
                        getHorizontalSpace(width: 2.w),

            Text(
              'Parking Buddy',
              style: AppTextStyles.titleRegularUpper.copyWith(
                color: AppColor.whiteColor,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
            Spacer(),
          ],
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () async {
                await Get.to(() => const ProfileScreen());
                // Refresh profile image when returning from profile screen
                _loadUserImage();
              },
              child: Obx(() => CircleAvatar(
                backgroundColor: AppColor.whiteColor,
                radius: 18.sp,
                backgroundImage: _userProfileImage.value.isNotEmpty
                    ? NetworkImage(_userProfileImage.value)
                    : null,
                child: _userProfileImage.value.isEmpty
                    ? Icon(
                        Icons.person, 
                        color: AppColor.darkGreyColor,
                        size: 24.sp,
                      )
                    : null,
              )),
            ),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kPeshawar,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        compassEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(_kPeshawar));
        },
        backgroundColor: AppColor.primaryColor,
        child: Icon(
          Icons.my_location,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}