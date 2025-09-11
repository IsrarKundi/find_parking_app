import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../authentication/auth_navigator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
          child: Column(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 15.w,
                backgroundColor: AppColor.primaryColor,
                child: Icon(
                  Icons.person,
                  size: 20.w,
                  color: AppColor.whiteColor,
                ),
              ),
              getVerticalSpace(height: 3.h),
              // User Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      Text(
                        'John Doe',
                        style: AppTextStyles.titleBoldUpper.copyWith(
                          fontSize: 20.sp,
                          color: AppColor.blackColor,
                        ),
                      ),
                      getVerticalSpace(height: 1.h),
                      Text(
                        'john.doe@example.com',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.darkGreyColor,
                        ),
                      ),
                      getVerticalSpace(height: 1.h),
                      Text(
                        '+92 300 1234567',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              getVerticalSpace(height: 4.h),
              // Action Buttons
              CustomElevatedButton(
                text: 'Edit Profile',
                onPressed: () {
                  // Dummy action
                  Get.snackbar(
                    'Edit Profile',
                    'Feature coming soon!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColor.primaryColor,
                    colorText: AppColor.whiteColor,
                  );
                },
              ),
              getVerticalSpace(height: 2.h),
              CustomElevatedButton(
                text: 'My Bookings',
                onPressed: () {
                  // Dummy action
                  Get.snackbar(
                    'My Bookings',
                    'No bookings yet!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColor.primaryColor,
                    colorText: AppColor.whiteColor,
                  );
                },
              ),
              getVerticalSpace(height: 2.h),
              CustomElevatedButton(
                text: 'Logout',
                onPressed: () {
                  Get.offAll(() => const AuthNavigator());
                },
                backgroundColor: AppColor.greyColor,
                textColor: AppColor.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}