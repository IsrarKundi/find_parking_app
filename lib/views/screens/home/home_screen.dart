import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/shared_preferences_service.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../controller/getx_controllers/user_home_controller.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../profile/profile_screen.dart';
import '../navigation/navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final _userProfileImage = RxString('');
  final UserHomeController _homeController = Get.put(UserHomeController());

  CameraPosition get _initialPosition => CameraPosition(
    target: LatLng(
      _homeController.userLat.value,
      _homeController.userLng.value,
    ),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _loadUserImage();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Wait for the controller to be initialized with user location
    await _homeController.loadUserLocation();
    if (!mounted) return;

    // Once we have the controller and user location, move the camera
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_initialPosition),
    );
  }

  Future<void> _loadUserImage() async {
    final image = await SharedPreferencesService.getUserImage();
    if (mounted) {
      _userProfileImage.value = image ?? '';
    }
  }

  void _onMarkerTap(MarkerId markerId) async {
    final marker = _homeController.markers.firstWhere((m) => m.markerId == markerId);
    final parking = _homeController.parkingLots.value!.data.firstWhere((p) => p.id == markerId.value);

    await Get.dialog(
      AlertDialog(
        title: Text(
          'Parking Details',
          style: AppTextStyles.titleBoldUpper.copyWith(
            color: AppColor.blackColor,
            fontSize: 18.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parking.username,
              style: AppTextStyles.bodyBoldUpper.copyWith(
                color: AppColor.blackColor,
                fontSize: 16.sp,
              ),
            ),
            getVerticalSpace(height: 1.h),
            Text(
              'Available Spots: ${parking.availableParkingSpots}',
              style: AppTextStyles.bodyRegularUpper.copyWith(
                color: AppColor.blackColor, 
                fontSize: 14.sp,
              ),
            ),
            getVerticalSpace(height: 0.5.h),
            Text(
              'Price: Rs. ${parking.pricePerSlot}',
              style: AppTextStyles.bodyRegularUpper.copyWith(
                color: AppColor.blackColor,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: AppTextStyles.bodyRegularUpper.copyWith(
                color: AppColor.primaryColor,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: CustomElevatedButton(
              text: 'Navigate',
              onPressed: () {
                Get.back();
                final position = marker.position;
                Get.to(() => NavigationScreen(
                  destinationLat: position.latitude,
                  destinationLng: position.longitude,
                  destinationName: parking.username,
                  parkingPrice: parking.pricePerSlot.toDouble(),
                ));
              },
              horizontalPadding: 1.h,
              verticalPadding: 0.5.h,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    // Handle map tap if needed
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
      body: Stack(
        children: [
         
             Obx(() => GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _homeController.markers.map((marker) {
                return marker.copyWith(
                  onTapParam: () => _onMarkerTap(marker.markerId),
                );
              }).toSet(),
              onTap: _onMapTapped,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              compassEnabled: true,
            )),
          // Distance selector dropdown
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() => DropdownButton<int>(
                value: _homeController.selectedDistance.value,
                items: _homeController.distanceOptions
                    .map((int distance) => DropdownMenuItem<int>(
                          value: distance,
                          child: Text('${distance}km radius'),
                        ))
                    .toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    _homeController.updateDistance(newValue);
                  }
                },
                underline: SizedBox(),
                icon: Icon(Icons.tune, color: AppColor.primaryColor),
              )),
            ),
          ),
          // Loading indicator
          Obx(() {
            if (_homeController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              );
            }
            return SizedBox();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
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