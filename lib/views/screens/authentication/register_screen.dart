import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: AppTextStyles.titleBoldUpper.copyWith(fontSize: 24.sp),
              ),
              getVerticalSpace(height: 4.h),
              myCustomTextField(
                hintText: 'Name',
                controller: nameController,
              ),
              getVerticalSpace(height: 2.h),
              myCustomTextField(
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              getVerticalSpace(height: 2.h),
              myCustomTextField(
                hintText: 'Password',
                isPasswordField: true,
                controller: passwordController,
              ),
              getVerticalSpace(height: 2.h),
              myCustomTextField(
                hintText: 'Confirm Password',
                isPasswordField: true,
                controller: confirmPasswordController,
              ),
              getVerticalSpace(height: 4.h),
              CustomElevatedButton(
                text: 'Register',
                onPressed: () {
                  // Navigate back to Login
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}