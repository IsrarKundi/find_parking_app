import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../../data/dummy_parking_data.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../parking_details/parking_details_screen.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.greyColor,
          child: Center(
            child: Text(
              'Map Here',
              style: AppTextStyles.titleBoldUpper.copyWith(fontSize: 20.sp),
            ),
          ),
        ),
        // Mock markers
        Positioned(
          top: 20.h,
          left: 20.w,
          child: GestureDetector(
            onTap: () {
              Get.to(() =>  ParkingDetailsScreen(parking: dummyParkings[0]));
            },
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_parking,
                color: AppColor.whiteColor,
                size: 5.w,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40.h,
          right: 20.w,
          child: GestureDetector(
            onTap: () {
              Get.to(() =>  ParkingDetailsScreen(parking: dummyParkings[1],));
            },
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_parking,
                color: AppColor.whiteColor,
                size: 5.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}