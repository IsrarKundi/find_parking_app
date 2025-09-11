import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/views/screens/authentication/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.primaryColor,
                      size: 6.w,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                /// Logo or Illustration
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 6.h,
                    color: AppColor.primaryColor,
                  ),
                ),

                SizedBox(height: 3.h),

                /// Title
                Text(
                  'Reset Password',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Enter your new password',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 5.h),

                /// New Password field
                myCustomTextField(
                  hintText: 'New Password',
                  isPasswordField: true,
                  controller: _authController.newPasswordController,
                ),

                SizedBox(height: 2.5.h),

                /// Confirm Password field
                myCustomTextField(
                  hintText: 'Confirm New Password',
                  isPasswordField: true,
                  controller: _authController.confirmNewPasswordController,
                ),

                SizedBox(height: 4.h),

                /// Reset Password Button
                Obx(() => CustomElevatedButton(
                  text: 'Reset Password',
                  onPressed: _authController.resetPassword,
                  isLoading: _authController.isLoading.value,
                )),

                SizedBox(height: 3.h),

                /// Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember your password? ",
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(LoginScreen());
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}