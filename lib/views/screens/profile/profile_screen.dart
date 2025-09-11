import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/getx_controllers/profile_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../authentication/auth_navigator.dart';
import 'edit_profile_popup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController());

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
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppColor.whiteColor,
            ),
            onPressed: () => _profileController.refreshProfile(),
          ),
        ],
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
        child: Obx(() {
          if (_profileController.isLoading.value && _profileController.userProfile.value == null) {
            // Show loading indicator when data is empty and loading
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                    getVerticalSpace(height: 2.h),
                    Text(
                      'Loading profile...',
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: AppColor.darkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(4.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Avatar
                  Obx(() {
                    final profileImage = _profileController.userProfileImage;
                    return CircleAvatar(
                      radius: 15.w,
                      backgroundColor: AppColor.primaryColor,
                      backgroundImage: profileImage.isNotEmpty
                          ? NetworkImage(profileImage)
                          : null,
                      child: profileImage.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 20.w,
                              color: AppColor.whiteColor,
                            )
                          : null,
                    );
                  }),
                  getVerticalSpace(height: 3.h),
                  // User Info Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Obx(() => Column(
                        children: [
                          Text(
                            _profileController.userDisplayName,
                            style: AppTextStyles.titleBoldUpper.copyWith(
                              fontSize: 20.sp,
                              color: AppColor.blackColor,
                            ),
                          ),
                          getVerticalSpace(height: 1.h),
                          Text(
                            _profileController.userEmail,
                            style: AppTextStyles.bodyRegularUpper.copyWith(
                              color: AppColor.darkGreyColor,
                            ),
                          ),
                          getVerticalSpace(height: 1.h),
                          Text(
                            'Role: ${_profileController.userRole}',
                            style: AppTextStyles.bodyRegularUpper.copyWith(
                              color: AppColor.darkGreyColor,
                            ),
                          ),
                          getVerticalSpace(height: 1.h),
                          Text(
                            'Location: ${_profileController.userLatitude.toStringAsFixed(4)}, ${_profileController.userLongitude.toStringAsFixed(4)}',
                            style: AppTextStyles.bodyRegularUpper.copyWith(
                              color: AppColor.darkGreyColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                  getVerticalSpace(height: 4.h),
                  // Loading indicator for actions
                  if (_profileController.isLoading.value)
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  // Action Buttons
                  CustomElevatedButton(
                    text: 'Edit Profile',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const EditProfilePopup(),
                      );
                    },
                  ),
                  getVerticalSpace(height: 2.h),
              
                  CustomElevatedButton(
                    text: 'Logout',
                    onPressed: () => _authController.logout(),
                    backgroundColor: AppColor.greyColor,
                    textColor: AppColor.blackColor,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}