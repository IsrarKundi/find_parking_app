import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/getx_controllers/auth_controller.dart';
import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                /// Logo or Illustration
                SizedBox(height: 4.h),
                Container(
                  height: 12.h,
                  width: 12.h,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_outline,
                      size: 6.h, color: AppColor.primaryColor),
                ),

                SizedBox(height: 3.h),

                /// Title
                Text(
                  'Welcome Back!',
                  style: AppTextStyles.titleBoldUpper.copyWith(
                    fontSize: 22.sp,
                    color: AppColor.primaryColor,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  'Login to continue to Parking Buddy',
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
                  controller: _authController.loginEmailController,
                ),
                SizedBox(height: 2.5.h),

                /// Password field
                myCustomTextField(
                  hintText: 'Password',
                  isPasswordField: true,
                  controller: _authController.loginPasswordController,
                ),

                /// Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodyRegularUpper.copyWith(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                /// Login Button
                Obx(() => CustomElevatedButton(
                      text: 'Login',
                      onPressed: _authController.login,
                      isLoading: _authController.isLoading.value,
                    )),

                SizedBox(height: 3.h),

                /// Divider with "or"
               

                SizedBox(height: 1.h),

                

                /// Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        color: Colors.grey.shade700,
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }


}
