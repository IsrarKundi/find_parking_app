import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../models/parking_model.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../navigation/navigation_screen.dart';

class ParkingDetailsScreen extends StatelessWidget {
  final Parking parking;

  const ParkingDetailsScreen({super.key, required this.parking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parking Details',
          style: AppTextStyles.titleBoldUpper.copyWith(
            color: AppColor.whiteColor,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.whiteColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primaryColor.withOpacity(0.1),
              AppColor.whiteColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Parking Icon
                  Center(
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_parking,
                        color: AppColor.whiteColor,
                        size: 12.w,
                      ),
                    ),
                  ),
                  getVerticalSpace(height: 3.h),
                  Text(
                    parking.name,
                    style: AppTextStyles.titleBoldUpper.copyWith(
                      fontSize: 20.sp,
                      color: AppColor.blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  getVerticalSpace(height: 2.h),
                  _buildInfoRow('Address', parking.address),
                  getVerticalSpace(height: 1.5.h),
                  _buildInfoRow('Price', 'Rs. ${parking.price}/hour'),
                  getVerticalSpace(height: 1.5.h),
                  _buildInfoRow('Available Spots', '${parking.availableSpots} spots'),
                  getVerticalSpace(height: 1.5.h),
                  _buildInfoRow('Hours', parking.hours),
                  getVerticalSpace(height: 4.h),
                  CustomElevatedButton(
                    text: 'Navigate to Parking',
                    onPressed: () {
                      Get.to(() => const NavigationScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.bodyBoldUpper.copyWith(
            color: AppColor.blackColor,
            fontSize: 14.sp,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyRegularUpper.copyWith(
              color: AppColor.darkGreyColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}