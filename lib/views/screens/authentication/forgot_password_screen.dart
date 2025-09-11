import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password',
                style: AppTextStyles.titleBoldUpper.copyWith(fontSize: 24.sp),
              ),
              getVerticalSpace(height: 4.h),
              myCustomTextField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              getVerticalSpace(height: 4.h),
              CustomElevatedButton(
                text: 'Reset Password',
                onPressed: () {
                  Get.snackbar(
                    'Reset Password',
                    'Password reset link sent to your email',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColor.primaryColor,
                    colorText: AppColor.whiteColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}