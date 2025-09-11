import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
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

                /// Logo
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user,
                    size: 6.h,
                    color: AppColor.primaryColor,
                  ),
                ),

                SizedBox(height: 3.h),

                /// Title
                Text(
                  'Verify OTP',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Enter the 4-digit OTP sent to your email',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  _authController.userEmail.value,
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 5.h),

                /// OTP input boxes
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _authController.otpController,
                  keyboardType: TextInputType.number,
                  textStyle: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 18.sp,
                    color: AppColor.blackColor,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 7.h,
                    fieldWidth: 13.w,
                    inactiveColor: Colors.grey.shade300,
                    activeColor: AppColor.primaryColor,
                    selectedColor: AppColor.primaryColor,
                  ),
                  onChanged: (value) {},
                ),

                SizedBox(height: 4.h),

                /// Verify OTP Button
                Obx(() => CustomElevatedButton(
                      text: 'Verify OTP',
                      onPressed: _authController.verifyOtp,
                      isLoading: _authController.isLoading.value,
                    )),

                SizedBox(height: 3.h),

                /// Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive OTP? ",
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _authController.forgotPassword();
                      },
                      child: Text(
                        'Resend',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                /// Change Email
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Change Email',
                    style: AppTextStyles.bodyRegularUpper.copyWith(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
