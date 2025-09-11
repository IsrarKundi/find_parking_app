import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/profile_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_profileController.isLoading.value && _profileController.userProfile.value == null) {
        // Show loading indicator when data is empty and loading
        return Center(
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
        );
      }

      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Profile Header
            Row(
              children: [
                // Profile Avatar
                Obx(() {
                  final profileImage = _profileController.userProfileImage;
                  return CircleAvatar(
                    radius: 8.w,
                    backgroundColor: AppColor.primaryColor,
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage(profileImage)
                        : null,
                    child: profileImage.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 10.w,
                            color: AppColor.whiteColor,
                          )
                        : null,
                  );
                }),
                getHorizontalSpace(width: 3.w),
                // User Info
                Expanded(
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.darkGreyColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        _profileController.userDisplayName,
                        style: AppTextStyles.titleBoldUpper.copyWith(
                          fontSize: 18.sp,
                          color: AppColor.blackColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _profileController.userEmail,
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.darkGreyColor,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
                ),
                // Refresh Button
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppColor.primaryColor,
                    size: 6.w,
                  ),
                  onPressed: () => _profileController.refreshProfile(),
                ),
              ],
            ),
            getVerticalSpace(height: 2.h),
            // User Stats/Info
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Role',
                  _profileController.userRole == 'user' ? 'User' : 'Parking Owner',
                  Icons.account_circle,
                ),
                _buildStatItem(
                  'Location',
                  '${_profileController.userLatitude.toStringAsFixed(2)}, ${_profileController.userLongitude.toStringAsFixed(2)}',
                  Icons.location_on,
                ),
              ],
            )),
            // Loading indicator for actions
            if (_profileController.isLoading.value)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColor.primaryColor,
          size: 6.w,
        ),
        getVerticalSpace(height: 0.5.h),
        Text(
          label,
          style: AppTextStyles.bodyRegularUpper.copyWith(
            color: AppColor.darkGreyColor,
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyRegularUpper.copyWith(
            color: AppColor.blackColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}