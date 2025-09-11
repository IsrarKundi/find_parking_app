import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controller/utils/color.dart';
import '../../../controller/utils/text_styles.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({super.key});

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green, // bright green
              Colors.white, // light tone
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Top row with two images
            Positioned(
              top: 14.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageContainer('assets/pngs/onboarding_pngs/onboarding1.jpg'),
                    _buildImageContainer('assets/pngs/onboarding_pngs/onboarding2.jpg'),
                  ],
                ),
              ),
            ),

            // Center image
            Positioned(
              top: 24.h,
              child: _buildImageContainer(
                'assets/pngs/onboarding_pngs/onboaring3.jpg',
                width: MediaQuery.of(context).size.width * 0.5,
                height: 29.h,
              ),
            ),

            // Bottom white card with text & buttons
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(1),
                      blurRadius: 24,
                      spreadRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.h),
                      child: Text(
                        'Find Parking with Ease!',
                        style: AppTextStyles.titleBoldUpper.copyWith(
                          fontSize: 19.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    getVerticalSpace(height: .5.h),
                    Text(
                      'Sign in to access nearby parking spots, reserve spaces, and navigate effortlessly. Start your parking journey today!',
                      style: AppTextStyles.bodyRegularUpper.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 3.h),
                    CustomElevatedButton(
                      text: "Sign In",
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ),
                    CustomElevatedButton(
                      text: "Sign Up",
                      onPressed: () => Get.to(() => const RegisterScreen()),
                      backgroundColor: Colors.transparent,
                      textColor: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable method for image containers with border & rounded corners
  Widget _buildImageContainer(String assetPath, {double? width, double? height}) {
    return Container(
      width: width ?? 44.w,
      height: height ?? 29.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.h),
        border: Border.all(color: AppColor.whiteColor, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.h),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
