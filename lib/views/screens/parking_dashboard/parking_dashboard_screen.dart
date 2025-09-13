import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/views/custom_widgets/custom_widgets.dart';
import 'package:parking_app/views/widgets/update_parking_popup.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/parking_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../controller/utils/shared_preferences_service.dart';
import '../profile/profile_screen.dart';

class ParkingDashboardScreen extends StatefulWidget {
  ParkingDashboardScreen({super.key});

  @override
  State<ParkingDashboardScreen> createState() => _ParkingDashboardScreenState();
}

class _ParkingDashboardScreenState extends State<ParkingDashboardScreen> {
  final ParkingController _parkingController = Get.put(ParkingController());
  final _userProfileImage = RxString('');

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    final image = await SharedPreferencesService.getUserImage();
    if (mounted) {
      _userProfileImage.value = image ?? '';
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool fullWidth = false,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26.sp),
            SizedBox(height: 1.5.h),
            Text(
              value,
              style: AppTextStyles.titleBoldUpper.copyWith(
                fontSize: 20.sp,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTextStyles.bodyRegularUpper.copyWith(
                fontSize: 14.sp,
                color: AppColor.darkGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          'Parking Dashboard',
          style: AppTextStyles.titleBoldUpper.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await Get.to(() => ProfileScreen());
                // Refresh profile image when returning from profile screen
                _loadUserImage();
              },
              child: Obx(() => CircleAvatar(
                radius: 18.sp,
                backgroundColor: Colors.white,
                backgroundImage: _userProfileImage.value.isNotEmpty
                    ? NetworkImage(_userProfileImage.value)
                    : null,
                child: _userProfileImage.value.isEmpty
                    ? Icon(
                        Icons.person,
                        color: AppColor.primaryColor,
                        size: 20.sp,
                      )
                    : null,
              )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (_parkingController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.primaryColor),
          );
        }

        final parkingData = _parkingController.parkingLots.value?.data;

        if (parkingData == null || parkingData.isEmpty) {
          return Center(
            child: Text(
              'No parking data available',
              style: AppTextStyles.bodyRegularUpper.copyWith(
                fontSize: 16.sp,
                color: AppColor.darkGreyColor,
              ),
            ),
          );
        }

        final parking = parkingData[0]; // single parking for owner

        return SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Welcome Back 👋',
                style: AppTextStyles.bodyRegularLower.copyWith(
                  fontSize: 16.sp,
                  color: AppColor.blackColor,
                ),
              ),
              SizedBox(height: 0.1.h),
              Text(
                'Here’s your parking overview',
                style: AppTextStyles.titleBoldUpper.copyWith(
                  fontSize: 19.sp,
                  color: AppColor.blackColor,
                ),
              ),
              SizedBox(height: 3.h),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.directions_car_filled_outlined,
                      title: 'Total Slots',
                      value: '${parking.totalParkingSlots}',
                      color: AppColor.primaryColor,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle,
                      title: 'Available',
                      value: '${parking.availableParkingSpots}',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              _buildStatCard(
                icon: Icons.attach_money,
                title: 'Price per Slot',
                value: 'Rs. ${parking.pricePerSlot}',
                color: Colors.green,
                fullWidth: true,
              ),
             
              SizedBox(height: 3.h),
              CustomElevatedButton(
                text: 'Update Parking Info',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateParkingPopup(),
                  );
                },
              ),
              SizedBox(height: 2.h),
              CustomElevatedButton(
                text: 'Show Entries',
                onPressed: () {
                  // Get.to(() => ParkingEntriesScreen());
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
