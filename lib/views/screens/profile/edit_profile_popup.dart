import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/profile_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class EditProfilePopup extends StatefulWidget {
  const EditProfilePopup({super.key});

  @override
  State<EditProfilePopup> createState() => _EditProfilePopupState();
}

class _EditProfilePopupState extends State<EditProfilePopup> {
  final ProfileController _profileController = Get.put(ProfileController());
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    // Initialize with current user name
    _nameController = TextEditingController(text: _profileController.userDisplayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile',
              style: AppTextStyles.titleBoldUpper.copyWith(
                fontSize: 18.sp,
                color: AppColor.blackColor,
              ),
            ),
            getVerticalSpace(height: 3.h),
            // Avatar with camera icon
            Obx(() {
              final selectedImage = _profileController.selectedImage.value;
              final currentProfileImage = _profileController.userProfileImage;

              return Stack(
                children: [
                  CircleAvatar(
                    radius: 15.w,
                    backgroundColor: AppColor.primaryColor,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage)
                        : (currentProfileImage.isNotEmpty
                            ? NetworkImage(currentProfileImage)
                            : null),
                    child: (selectedImage == null && currentProfileImage.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 20.w,
                            color: AppColor.whiteColor,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 4.w,
                      backgroundColor: AppColor.whiteColor,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColor.blackColor,
                            size: 5.w,
                          ),
                          onPressed: _profileController.pickImage,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            getVerticalSpace(height: 3.h),
            // Name TextField
            myCustomTextField(
              hintText: 'Enter your name',
              controller: _nameController,
              fillColor: AppColor.greyColor,
              borderColor: AppColor.primaryColor,
            ),
            getVerticalSpace(height: 4.h),
            // Buttons
            Obx(() {
              final isLoading = _profileController.isLoading.value;
              final isImageUploading = _profileController.imageUploadLoading.value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: CustomElevatedButton(
                        text: 'Cancel',
                        onPressed: () {
                          // Clear selected image when canceling
                          _profileController.selectedImage.value = null;
                          Navigator.pop(context);
                        },
                        backgroundColor: AppColor.greyColor,
                        textColor: AppColor.blackColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: SizedBox(
                      height: 6.h,
                      child: CustomElevatedButton(
                        text: isLoading || isImageUploading ? 'Saving...' : 'Save',
                        onPressed: (isLoading || isImageUploading)
                            ? () {}
                            : () => _saveProfile(),
                        isLoading: isLoading || isImageUploading,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    // Validation is now handled in the controller
    await _profileController.updateProfileWithImage(
      username: _nameController.text.trim(),
    );

    // Close dialog after successful update (loading completed)
    if (!_profileController.isLoading.value && !_profileController.imageUploadLoading.value) {
      // Check if there were no errors by checking if we're still in loading state
      // If there was an error, the loading would have stopped but we don't auto-close
      bool hasErrors = Get.isSnackbarOpen == false; // Simple check
      if (!hasErrors) {
        Navigator.pop(context);
      }
    }
  }
}