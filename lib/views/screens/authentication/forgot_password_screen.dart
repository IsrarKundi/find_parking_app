import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                  'Forgot Password?',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Enter your email address and we\'ll send you an OTP to reset your password',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 5.h),

                /// Email field
                myCustomTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _authController.forgotEmailController,
                ),

                SizedBox(height: 4.h),

                /// Send OTP Button
                Obx(() => CustomElevatedButton(
                  text: 'Send OTP',
                  onPressed: _authController.forgotPassword,
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
                        Get.back();
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