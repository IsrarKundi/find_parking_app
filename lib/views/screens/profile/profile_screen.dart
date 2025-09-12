import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/getx_controllers/profile_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
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
      body: Obx(() {
        if (_profileController.isLoading.value &&
            _profileController.userProfile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColor.primaryColor),
                getVerticalSpace(height: 2.h),
                Text(
                  'Loading profile...',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    color: AppColor.darkGreyColor,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            /// Header with gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 7.h, bottom: 5.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primaryColor, AppColor.primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getVerticalSpace(height: 2.h),
                  // Profile Avatar
                  CircleAvatar(
                    radius: 14.w,
                    backgroundColor: Colors.white,
                    backgroundImage: _profileController.userProfileImage.isNotEmpty
                        ? NetworkImage(_profileController.userProfileImage)
                        : null,
                    child: _profileController.userProfileImage.isEmpty
                        ? Icon(Icons.person,
                            size: 14.w, color: AppColor.primaryColor)
                        : null,
                  ),
                  getVerticalSpace(height: 1.5.h),
                  Text(
                    _profileController.userDisplayName,
                    style: AppTextStyles.titleBoldUpper.copyWith(
                      fontSize: 20.sp,
                      color: AppColor.whiteColor,
                    ),
                  ),
                  getVerticalSpace(height: 0.5.h),
                  Text(
                    _profileController.userEmail,
                    style: AppTextStyles.bodyRegularUpper.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// Profile Details Card
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                child: Column(
                  children: [
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Role", _profileController.userRole),
                            Divider(color: Colors.grey.shade300, height: 3.h),
                            _buildInfoRow(
                              "Location",
                              "${_profileController.userLatitude.toStringAsFixed(4)}, ${_profileController.userLongitude.toStringAsFixed(4)}",
                            ),
                          ],
                        ),
                      ),
                    ),
                    getVerticalSpace(height: 4.h),

                    /// Edit Profile Button
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

                    /// Logout Button
                    CustomElevatedButton(
                      text: 'Logout',
                      onPressed: () async {
                        final result = await Get.dialog<bool>(
                          AlertDialog(
                            title: Text(
                              'Confirm Logout',
                              style: AppTextStyles.titleBoldUpper.copyWith(
                                color: AppColor.blackColor,
                                fontSize: 18.sp,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to logout? This will clear all your data.',
                              style: AppTextStyles.bodyRegularUpper.copyWith(
                                color: AppColor.darkGreyColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.bodyRegularUpper.copyWith(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: Text(
                                  'Logout',
                                  style: AppTextStyles.bodyRegularUpper.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (result == true) {
                          await _authController.logout();
                        }
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Helper method for cleaner rows
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyRegularUpper.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.darkGreyColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyRegularUpper.copyWith(
              fontSize: 16.sp,
              color: AppColor.blackColor,
            ),
          ),
        ),
      ],
    );
  }
}
