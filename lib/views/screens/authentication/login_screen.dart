import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import '../home/home_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: AppTextStyles.titleBoldUpper.copyWith(fontSize: 24.sp),
              ),
              getVerticalSpace(height: 4.h),
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
              getVerticalSpace(height: 4.h),
              CustomElevatedButton(
                text: 'Login',
                onPressed: () {
                  // Navigate to Home Screen
                  Get.offAll(() => const HomeScreen());
                },
              ),
              getVerticalSpace(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyRegularUpper,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const RegisterScreen());
                    },
                    child: Text(
                      'Register',
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              getVerticalSpace(height: 1.h),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ForgotPasswordScreen());
                },
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyles.bodyRegularUpper.copyWith(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
